% Visualise the results

load('RES.mat');

figure(2)
while true
    prompt = 'Enter query image number and class in format [im-no class].\n';
    ui = input(prompt)
    image = ui(1);
    class = ui(2);
    rank = find(ip_image_no==ui(1));
    q_im_path = RES(rank).TESTIMAGE(class);
    im_no=0;
    close figure 2
    figure(2);
    while im_no<(size(RES(rank).RESULT,2)+1)
        if im_no==0
            subplot(15,7,im_no+1)
            imshow(imread(q_im_path{1}))
            xlabel('Query Image')
        elseif size(RES(rank).RESULT{class,im_no},1)==0
            im_no;
        else
            subplot(15,7,im_no+1)
            imshow(imread(RES(rank).RESULT{class,im_no}))
        end
        im_no=im_no+1;
    end
end