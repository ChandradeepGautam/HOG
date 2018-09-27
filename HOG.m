images = (PATH of Training images);
pngfiles= dir(fullfile(images,'\*.png*'));
n=numel(pngfiles);
v=1;
im=1;
temp=0;
for n=1:n
    a=pngfiles(n).name;
    a=imread(fullfile(images,a));
    a=rgb2gray(a);
    a=im2double(a);
    a=imresize(a,[256,256]);
    [row1,column1]=size(a);
    row2=row1/8;
    column2=column1/8;
    row3=floor(row2);
    column3=floor(column2);
    row=256;column=256;
    a=imresize(a,[row column]);
    %figure,imshow(a);
    temp=temp+1;
    if mod(temp,100)==0
        close all;
        temp
    end
    dx=zeros(row,column);
    dy=zeros(row,column);
    mag=zeros(row,column);
    phase=zeros(row,column);

% Calculation of gradient in x direction
    for i=1:1:row
        for j=2:1:column-1
            dx(i,j)=a(i,j+1)-a(i,j-1);
        end 
    end 
    dx=dx*255;
% Calculation of gradient in y direction
    for i=2:1:row-1
        for j=1:1:column
            dy(i,j)=a(i+1,j)-a(i-1,j);
        end 
    end 
    dy=dy*255;
% Calculation of magnitude matrix
    for i=1:1:row
        for j=1:1:column
            dx2=power(dx(i,j),2);
            dy2=power(dy(i,j),2);
            mag(i,j)=sqrt(dx2+dy2);
        end 
    end 
% Calculation of phase matrix
    for i=1:1:row
        for j=1:1:column
            phase(i,j)=atand(dy(i,j)/dx(i,j));
            if phase(i,j)<0 
               phase(i,j)=phase(i,j)+180;
            end 
        end 
    end 
    for i=1:row3
        grid_array1(1,i)=8;
    end 
    for i=1:column3
        grid_array2(1,i)=8;
    end 
    grid=mat2cell(a,grid_array1,grid_array2);
    for i=1:row3
        mag_array1(1,i)=8;
    end 
    for i=1:column3
        mag_array2(1,i)=8;
    end 
    mag_grid=mat2cell(mag,mag_array1,mag_array2);
    for i=1:row3
        phase_array1(1,i)=8;
    end 
    for i=1:column3
        phase_array2(1,i)=8;
    end 
    phase_grid=mat2cell(phase,phase_array1,phase_array2);
    h=zeros(row3*column3,9);
    sum=0;w=1;
% Orientation binning
    for i=1:1:row3
        for j=1:1:column3
             for k=1:1:8
                for l=1:1:8
                    p=phase_grid{i,j}(k,l);
                    if (isnan(p))
                        p=0;
                    end
                    q=floor(mag_grid{i,j}(k,l));
                    if p>=160
                        val=p-160;
                        val0=val/20;
                        val2=q*val0;
                        h(w,1)=h(w,1)+val2;
                        val3=q-val2;
                        h(w,9)=h(w,9)+val3;
                    end
                    if p<160
                        VALUE=floor(p/20)*20;
                        value1=p-VALUE;
                        value2=value1/20;
                        value3=VALUE/20;
                        sum=q*value2;
                        h(w,value3+2)=h(w,value3+2)+sum;
                        value7=q-sum;
                        value6=value3+1;
                        h(w,value6)=h(w,value6)+value7;
                    end
                end
             end
             w=w+1;
        end 
    end 
    blocks=(row3-1)*(column3-1);
    g=zeros(blocks,36);
    r=1;
    for i=1:1:column3-1
        down=1;
        while down<row3
              for j=1:1:9
                  g(r,j)=h(down,j);
              end 
              for j=1:1:9
                  g(r,j+9)=h(down+row3,j);
              end 
              for j=1:1:9
                  g(r,j+18)=h(down+1,j);
              end 
              for j=1:1:9
                  g(r,j+27)=h(down+1+row3,j);
              end 
              r=r+1;down=down+1;
        end 
    end 
% Normalisation
    norm_factor=0;
    for i=1:1:blocks
        for j=1:1:36
            norm_factor=norm_factor+power(g(i,j),2);
        end 
        norm=sqrt(norm_factor);
        for j=1:1:36
            g(i,j)=g(i,j)/norm;
        end 
        norm_factor=0;
    end 
    [R,C]=size(g);
    s=1;
    reject=0;
        for k=1:R
            for l=1:C
                if g(k,l)==0
                    reject=reject+1;
                end
            end
        end
        if reject~=R*C
            for k=1:R
                for l=1:C
                    vector(v,s)=g(k,l);
                    s=s+1;
                end
            end
            if n<=500
               group(im,1)=0;
            end
            if n>500
                group(im,1)=1;
            end
            im=im+1;
        end
        v=v+1;
end 
 
% Training of dataset using SVM
SVMStruct = svmtrain(vector, group, 'Options', options);
images =(PATH of Training images);
pngfiles=dir(fullfile(images,'\*.ppm*'))
N=numel(pngfiles);
v=1;
for n=1:N
    a=pngfiles(n).name
    a=imread(fullfile(images,a))
    a=rgb2gray(a);
    a=im2double(a);
    a=imresize(a,[256 256]);
    [row1,column1]=size(a);
    row2=row1/8;
    column2=column1/8;
    row3=floor(row2);
    column3=floor(column2);
    row=256;
    column=256;
    a=imresize(a,[row column]);
    %figure,imshow(a);
    dx=zeros(row,column);
    dy=zeros(row,column);
    mag=zeros(row,column);
    phase=zeros(row,column);
    for i=1:1:row
        for j=2:1:column-1
            dx(i,j)=a(i,j+1)-a(i,j-1);
        end 
    end 
    dx=dx*255;
    for i=2:1:row-1
        for j=1:1:column
            dy(i,j)=a(i+1,j)-a(i-1,j);
        end 
    end 
    dy=dy*255;
    for i=1:1:row
        for j=1:1:column
            dx2=power(dx(i,j),2);
            dy2=power(dy(i,j),2);
            mag(i,j)=sqrt(dx2+dy2);
        end 
    end 
    for i=1:1:row
        for j=1:1:column
            phase(i,j)=atand(dy(i,j)/dx(i,j));
            if phase(i,j)<0 
               phase(i,j)=phase(i,j)+180;
            end 
        end 
    end 
    for i=1:row3
        grid_array1(1,i)=8;
    end 
    for i=1:column3
        grid_array2(1,i)=8;
    end 
    grid=mat2cell(a,grid_array1,grid_array2);
    for i=1:row3
        mag_array1(1,i)=8;
    end 
    for i=1:column3
        mag_array2(1,i)=8;
    end 
    mag_grid=mat2cell(mag,mag_array1,mag_array2);
    for i=1:row3
        phase_array1(1,i)=8;
    end 
    for i=1:column3
        phase_array2(1,i)=8;
    end 
    phase_grid=mat2cell(phase,phase_array1,phase_array2);
    h=zeros(row3*column3,9);
    sum=0;w=1;
    for i=1:1:row3
        for j=1:1:column3
             for k=1:1:8
                for l=1:1:8
                    p=phase_grid{i,j}(k,l);
                    if (isnan(p))
                        p=0;
                    end
                    q=floor(mag_grid{i,j}(k,l));
                    if p>=160
                        val=p-160;
                        val0=val/20;
                        val2=q*val0;
                        h(w,1)=h(w,1)+val2;
                        val3=q-val2;
                        h(w,9)=h(w,9)+val3;
                    end
                    if p<160
                        VALUE=floor(p/20)*20;
                        value1=p-VALUE;
                        value2=value1/20;
                        value3=VALUE/20;
                        sum=q*value2;
                        h(w,value3+2)=h(w,value3+2)+sum;
                        value7=q-sum;
                        value6=value3+1;
                        h(w,value6)=h(w,value6)+value7;
                    end
                end
             end
             w=w+1;
        end 
    end 
    blocks=(row3-1)*(column3-1);
    g=zeros(blocks,36);
    r=1;
    for i=1:1:column3-1
        down=1;
        while down<row3
            for j=1:1:9
                  g(r,j)=h(down,j);
              end 
              for j=1:1:9
                  g(r,j+9)=h(down+row3,j);
              end 
              for j=1:1:9
                  g(r,j+18)=h(down+1,j);
              end 
              for j=1:1:9
                  g(r,j+27)=h(down+1+row3,j);
              end 
              r=r+1;down=down+1;
        end 
    end 
    norm_factor=0;
    for i=1:1:blocks
        for j=1:1:36
            norm_factor=norm_factor+power(g(i,j),2);
        end 
        norm=sqrt(norm_factor);
        for j=1:1:36
            g(i,j)=g(i,j)/norm;
        end 
        norm_factor=0;
    end 
    [R,C]=size(g);
    s=1;
        for k=1:R
            for l=1:C
            Sample(v,s)=g(k,l);
            s=s+1;
            end
        end
        v=v+1;
end
% Testing of dataset using SVM Classifier
 Group = svmclassify(SVMStruct,Sample);



