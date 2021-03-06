clc; close all; clear;
globals;

proxnum = 1; subnum = 3;
name = PROXopts(proxnum).submix(subnum).name;

[pos, neg1, neg2, test] = PROXSUB_data(name,proxnum,subnum);
model = trainmodel(name,pos,neg1,neg2,PROXopts(proxnum).K,PROXopts(proxnum).pa,PROXopts(proxnum).co);

% Testing on one image for illustration
idx = 49;
fprintf([name ': testing: %d/%d\n'],idx,length(test));
im = imread(test(idx).im);
bbox.xy = [test(idx).x1 test(idx).y1 test(idx).x2 test(idx).y2];
bbox.force = test(idx).force;
box = detect(im,model,model.thresh,bbox,0.5);
prox.xy = reshape(box(1:end-2),4,floor(length(box)/4))';
prox.score = box(end);
figure(1);
showboxes(im, prox, PROXopts(proxnum).color);
figure(2);
showskeletons(im, prox, PROXopts(proxnum).pa, PROXopts(proxnum).color);
fprintf('press any key to continue ...\n');
waitforbuttonpress;

% Testing on all images with ground truth face location as the face anchor
suffix = ['test_' num2str(PROXopts(proxnum).K')'];
proxes_test = testmodel(name,model,test,suffix);
%PCK = PROX_eval_pck(proxes_test,test,proxnum);
%fprintf('PCK=%.1f\n',PCK*100); fprintf('R = '); fprintf('& %.1f ',R*100); fprintf('\n');
[ap, prec, rec] = PROX_eval_ap(proxes_test,test);
fprintf('ap=%.1f\n',ap*100);

% Testing on all images with face detection as the face results
suffix = ['test_face_' num2str(PROXopts(proxnum).K')'];
proxes_test_face = testmodel_face(name,model,test,suffix);
%PCK = PROX_eval_pck(proxes_test_face,test,proxnum);
%fprintf('PCK=%.1f\n',PCK*100); fprintf('R = '); fprintf('& %.1f ',R*100); fprintf('\n');
[ap, prec, rec] = PROX_eval_ap(proxes_test_face,test);
fprintf('ap=%.1f\n',ap*100);
