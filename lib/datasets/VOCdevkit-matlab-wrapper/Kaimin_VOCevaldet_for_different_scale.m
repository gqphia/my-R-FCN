function [rec,prec,ap] = Kaimin_VOCevaldet_for_different_scale(VOCopts,id,cls,draw,count)
fprintf('this is count %d\n', count);
% load test set
gtids=textread(sprintf(VOCopts.imgsetpath,VOCopts.testset),'%s');
%save('error_guo2.mat','gtids');
fprintf('imgsetpath=%s\n',VOCopts.imgsetpath);
fprintf('testset=%s\n',VOCopts.testset);
sprintf(VOCopts.imgsetpath,VOCopts.testset)

% load ground truth objects
tic;
npos=0;
%%%%%%%%%%%%%%%%%%%%%%Kaimin's modification%%%%%%%%%%%%%%%%%%
NumOfBin = 10;
Max_width = 590;
Min_width = 0;
npos_for_bins = zeros(1,NumOfBin);
Step=(Max_width - Min_width)/NumOfBin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gt(length(gtids))=struct('BB',[],'diff',[],'det',[], 'dontcare',[]);
for i=1:length(gtids)
    % display progress
    if toc>1
        fprintf('%s: pr: load: %d/%d\n',cls,i,length(gtids));
        drawnow;
        tic;
    end
    
    % read annotation
    rec=PASreadrecord(sprintf(VOCopts.annopath,gtids{i}));

    [a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15]= ...
    	textread(sprintf(VOCopts.dontcare,gtids{i}),...
	'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
    % extract objects of class
    clsinds=strmatch(cls,lower({rec.objects(:).class}),'exact');
    gt(i).BB=cat(1,rec.objects(clsinds).bbox)';
    for x = 1:size(gt(i).BB,2)
        ind_for_bin = get_index_by_width(gt(i).BB(3,x)-gt(i).BB(1,x))
        npos_for_bins(ind_for_bin)= npos_for_bins(ind_for_bin)+1
    end
    gt(i).diff=zeros(length(clsinds),1);
    gt(i).det=false(length(clsinds),1);
    dc=strmatch('DontCare',a1,'exact');
    gt(i).dontcare=[a5(dc),a6(dc),a7(dc),a8(dc)]';
    if length(gt(i).dontcare~=0)
        disp(i)
    end
    npos=npos+sum(~gt(i).diff);
end
assert (sum(npos_for_bins) == npos)
fprintf('finish read ground truth\n');
% load results
[ids,confidence,b1,b2,b3,b4]=textread(sprintf(VOCopts.detrespath,id,cls),'%s %f %f %f %f %f');
fprintf('VOCopts.detrespath=%s\n', VOCopts.detrespath);
BB=[b1 b2 b3 b4]';
fprintf('after read result\n');

% sort detections by decreasing confidence
[sc,si]=sort(-confidence);
ids=ids(si);
BB=BB(:,si);
%save('error_guo1.mat','gtids','gt','cls','ids','confidence');
% assign detections to ground truth objects
nd=length(confidence);

tp=zeros(nd,1);
fp=zeros(nd,1);
tp_for_bins=zeros(nd,NumOfBin);
fp_for_bins=zeros(nd,NumOfBin);

tic;

% write fp and fp
fid_tp = fopen('tp.txt','wt');
fid_fp = fopen('fp.txt','wt');


for d=1:nd
    % display progress
    if toc>1
        fprintf('%s: pr: compute: %d/%d\n',cls,d,nd);
        drawnow;
        tic;
    end
    
    % find ground truth image
    i=strmatch(ids{d},gtids,'exact');
    if isempty(i)
	%save('error_guo.mat','ids','d','gtids');
        error('unrecognized image "%s"',ids{d});
    elseif length(i)>1
        error('multiple image "%s"',ids{d});
    end

    % assign detection to ground truth object if any
    bb=BB(:,d);
    ovmax=-inf;
    for j=1:size(gt(i).BB,2)
        bbgt=gt(i).BB(:,j);
        bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
        iw=bi(3)-bi(1)+1;
        ih=bi(4)-bi(2)+1;
        if iw>0 & ih>0                
            % compute overlap as area of intersection / area of union
            ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
               (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
               iw*ih;
            ov=iw*ih/ua;
            if ov>ovmax
                ovmax=ov;
                jmax=j;
            end
        end
    end
    % assign detection as true positive/don't care/false positive
    if ovmax>=VOCopts.minoverlap
        ind_for_bin = get_index_by_width(gt(i).BB(3,jmax)-gt(i).BB(1,jmax))
        if ~gt(i).diff(jmax)
            if ~gt(i).det(jmax)
                tp(d)=1;            % true positive
                tp_for_bins(d,ind_for_bin)=1;
		gt(i).det(jmax)=true;
		fprintf(fid_tp,'%d %d %d %d\n',bb(1),bb(2),bb(3),bb(4));
            else
                fp(d)=1;            % false positive (multiple detection)
                fp_for_bins(d,ind_for_bin)=1;
		fprintf(fid_fp,'%d %d %d %d\n',bb(1),bb(2),bb(3),bb(4));
            end
        end
    else
        if ~(find_dontcare(bb, gt(i).dontcare)>=VOCopts.minoverlap)
            fp(d)=1;                    % false positive
            fp_for_bins(d,ind_for_bin)=1;
	    fprintf(fid_fp,'%d %d %d %d\n',bb(1),bb(2),bb(3),bb(4));
        end
    end
end
save('error_guo1.mat','gt','gtids');
fclose(fid_tp);
fclose(fid_fp);
% compute precision/recall
fp=cumsum(fp);
fp_for_bins=cumsum(fp_for_bins);
tp=cumsum(tp);
tp_for_bins=cumsum(tp_for_bins);
rec=tp/npos;
rec_for_bins = tp_for_bins./(repmat(npos_for_bins,size(tp_for_bins,1),1));
prec=tp./(fp+tp);
prec_for_bins = tp_for_bins./(fp_for_bins+tp_for_bins);
% compute average precision

ap=0;ap_for_bins=zeros(1,NumOfBin);p_for_bins=zeros(1,NumOfBin)
for t=0:0.1:1
    p=max(prec(rec>=t));
    for x = 1:NumOfBin
        
        temp = max(prec_for_bins(rec_for_bins(:,x)>=t,x))
        if isempty(temp)
            p_for_bins(x)=0
        else
            p_for_bins(x) =temp
        end
    end
    if isempty(p)
        p=0;
    end
    ap=ap+p/11
    ap_for_bins = ap_for_bins + p_for_bins./11
end
save('error_guo2.mat','ap','rec','prec');
if draw
    % plot precision/recall
    count
    figure(count);
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    title(sprintf('class: %s, subset: %s, AP = %.3f',cls,VOCopts.testset,ap));
    
    figure(count+1);hold on;
    %plot(ap_for_bins(ap_for_bins>0))
    plot(ap_for_bins);
    grid;
    xlabel 'Id of bin'
    ylabel  'Ap'
    save('scale_equals_.mat','ap_for_bins','prec','rec','ap')
end
end
function ovmax = find_dontcare(bb, dc)
    ovmax=-inf;
    for j=1:size(dc,2)
        bbgt=dc(:,j);
        bi=[max(bb(1),bbgt(1)) ; max(bb(2),bbgt(2)) ; min(bb(3),bbgt(3)) ; min(bb(4),bbgt(4))];
        iw=bi(3)-bi(1)+1;
        ih=bi(4)-bi(2)+1;
        if iw>0 & ih>0
            % compute overlap as area of intersection / area of union
            ua=(bb(3)-bb(1)+1)*(bb(4)-bb(2)+1)+...
               (bbgt(3)-bbgt(1)+1)*(bbgt(4)-bbgt(2)+1)-...
               iw*ih;
            ov=iw*ih/ua;
            if ov>ovmax
                ovmax=ov;
                jmax=j;
            end
        end
    end
end
function indx = get_index_by_width(width)
    
bound = [0.46, 32.20, 41.84, 53.16, 66.35, 83.57, 107.45, 140.06, 194.66, 297.59]
%bound = [0.46, 14.4418, 16.1968, 18.4372, 21.3970, 25.4888,31.5156,41.2750, 59.7902,108.4301]
indx=0
if width >=  max(bound)
    indx = 10;
else
    for i=1:9
        if(width>=bound(i) && width < bound(i+1))
            indx=i;
            break;
        end
    end
end
end
