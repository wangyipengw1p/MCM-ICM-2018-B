clear;close all;
%---------------------------------------------------------------------
%元胞结构
% 1	洲
% 2	洲内编号？？？
% 3	人口
% 4 5 6	三语言
%-------------------------------------------------------------------------
clear;close all
I1=imread('map1_200.png');
[x,y,~] = size(I1);
I2 = double(rgb2gray(imread('map2_200.png')));
I3 = imread('map3_200.png');
%定义 button---------------------------------------------------------------
plotbutton=uicontrol('style','pushbutton',...
'string','Run',...
'fontsize',12,...
'position',[100,400,50,20],...
'callback','run=1;');
erasebutton=uicontrol('style','pushbutton',...
'string','Stop',...
'fontsize',12,...
'position',[300,400,50,20],...
'callback','freeze=1;');
number=uicontrol('style','text',...
'string','1',...
'fontsize',12,...
'position',[20,400,50,20]);
%处理图像----------------------------------------------------------
t0 = 0; t1 = 0; t2 = 0; t3 = 0; t4 = 0; t5 = 0; t6 = 0;
worldPopu = 76000;
W = 0;

for i=1:x
    for j=1:y
        a = I1(i,j,:);
       
        c = I3(i,j,:);
        %图片一大洲分布
        if a(1)<=10 && a(2) > 70 && a(2) < 120 && a(3) > 120 && a(3) <175
            cells(i,j,1) = 1;
            t1 = t1 +1;
        elseif a(1)>=230 && a(2)>=230 && a(3)<=70
            cells(i,j,1) = 3;
            t3 = t3 +1;
        elseif a(1)>=110 && a(1)<=180 && a(2) > 5 && a(2) < 65 && a(3) > 80 && a(3) < 165
            cells(i,j,1) = 2;
            t2 = t2 +1;
        elseif a(1)>=180 && a(1)<=205 && a(2) > 185 && a(2) < 210 && a(3) > 30 && a(3) < 60
            cells(i,j,1) = 4;
            t4 = t4 +1;
        elseif a(1)>=185 && a(1)<=220 && a(2) > 50 && a(2) < 120 &&  a(3) < 45
            cells(i,j,1) = 5;
            t5 = t5 +1;
        elseif a(1)>190 && a(1) < 215  && a(2) > 105 && a(2) < 130 &&  a(3) > 100 && a(3) < 130 
            cells(i,j,1) = 6;
            t6 = t6 +1;
        else
            cells(i,j,1) = 0;
            t0 = t0 +1;
        end
        %图片二：人口分布（计算总白度）
        
        W  = W  - I2(i,j)+ 255;
        %图片三: 母语分布
        cells(i,j,4) = nativLan(c(1),c(2),c(3),cells(i,j,1));
    end
end

dens = worldPopu / W;
for i=1:x
    for j=1:y
        if cells(i,j,1) == 0
            cells(i,j,3) = 0;
        else
            cells(i,j,3) = (255 - I2(i,j)) * dens;
        end
    end
end

%设定初值-------------------------------------------------------------------

%人口
%     2亚洲4，358，766，000      4.36
%     3欧洲739，256，405            0.74
%     1非洲1，178，051，100     1.18
%     5大洋洲39，314，049         0.04 
%     4北美洲 356,655,000           0.3566   billion
%     6南美洲 618，797，000        0.6188


p1 = 1180;%人口
p2 = 4360;
p3 = 740;
p4 = 975;
p5 = 40;
p6 = 619;

pop1 = p1 / t1;%每格人口
pop2 = p2 / t2;
pop3 = p3 / t3;
pop4 = p4 / t4;
pop5 = p5 / t5;
pop6 = p6 / t6;

r1 = 0.025;%自然增长率
r2 = 0.011;
r3 = 0.0001;
r4 = 0.004;
r5 = 0.011;
r6 = 0.012;

k1 = 2226;
k2 = 7965;
k3 = 3589;
k4 = 1112;
k5 = 822;
k6 = 2172;
%--------------------------------------------proportion
prop1 = 0.6;%第二语言人数比率
prop2 = 0.1;%多门语言人数比率
prop3 = 0.5;%native change rate
prop4 = 0.005;%第二语言习得增长率
prop5 = 0.002;%第三语言习得增长率
prop6 =0.08; %第二语言被周围影响获取概率
prop7 = 0.8;% 6*7 跨洲语言传播概率
prop8 = 0.5;%6*7 跨洋每步传播概率
prop9 = 0.05;%人口扩散概率
prop0 = 0.02;%人口迁移概率
%第二语言比例
% 1中文	0.101
% 2西班牙语	0.0473
% 3英语	0.3188
% 4印度	0.09
% 5阿拉伯	0.14
% 6孟加拉	0.1
% 7葡萄牙	0.0058
% 8俄罗斯	0.0594
% 9旁遮普语	0.012
% 10日语	0.0005
% 11非洲其他	0.0003
%12法语	0.0975
%13德语	0.0274
lTwo = 1:13;
pTwo = [0.101 0.0473 0.3188 0.09 0.14 0.1 0.0058 0.0594 0.012 0.0005 0.0003 0.0975 0.0274];



%母语比例
lAsia = [1 5 4 10 6 9];
pAsia = [0.461 0.097 0.232 0.050 0.097 0.063];
lEur = [3 2 7 8 13 12];
pEur = [0.159 0.101 0.027 0.281 0.257 0.175];
lSou = [7 2 3];
pSou = [0.317 0.583 0.1];
lAf = [5 7 3 11];
pAf = [0.253 0.027 0.012 0.708];
t0 = 0; t1 = 0; t2 = 0; t3 = 0; t4 = 0; t5 = 0; t6 = 0;
for i = 1 : x
    for j = 1: y
        %随机获得第二 三语言
        if rand < prop1
            cells(i,j,5) = randsrc(1,1,[lTwo;pTwo]);
            if rand < prop2
                cells(i,j,6) = randsrc(1,1,[lTwo;pTwo]);
            end
        end
    end
end




%==========================================================================main
run=0;
freeze=0;
stop=0;

global n;
global buffer1;%haiyang 
global buffer2;%不同洲的2 3 语言



while (stop==0)
    if(run==1)
        
        for i=1:x
            for j=1:y
                if cells(i,j,1) == 0
                    continue;
                end
                if i-1 > 0    % 处理越界
                    ii = i-1;
                else
                    ii = x;
                end
                if j-1 > 0
                    jj = j-1;
                else
                    jj = y;
                end
                if i+1 < x+1
                    iii = i+1;
                else
                    iii = 1;
                end
                if j+1 < y+1
                    jjj = j+1;
                else
                    jjj = 1;
                end
                %处理
                %popuGrowth();------------------------
                switch cells(i,j,1)
                    case 1
                        r = r1;k = k1;
                    case 2
                        r = r2; k =k2;
                    case 3
                        r = r3;k = k3;
                    case 4
                        r = r4; k = k4;
                    case 5
                        r = r5;k = k5;
                    case 6
                        r = r6;k = k6;
                    otherwise 
                        r = 0; k = rand;
                end
                t = cells(i,j,3);
                tt = (1+r)*t - r*t*t/k;
                cells(i,j,3) = tt;
                %-------------------------------------
                %nativChange();------------------------
                t = [cells(ii,j,4) cells(ii,jj,4) cells(ii,jjj,4) cells(i,jj,4)...
                    cells(i,jjj,4) cells(iii,j,4) cells(iii,jjj,4) cells(iii,jj,4)...
                    cells(ii,j,5) cells(ii,jj,5) cells(ii,jjj,5) cells(i,jj,5)...
                    cells(i,jjj,5) cells(iii,j,5) cells(iii,jjj,5) cells(iii,jj,5)];
                tt = sortrows(tabulate(t),2);
                if tt (1,2) >=6 && t(1,1) ~= 0 && t(1,1) ~= cells(i,j,4)
                    if rand < prop3
                            cells(i,j,4) = tt(1,1);
                    end
                end
                    
                %-------------------------------------
                %23Change();--------------------------
                %随机赋予
               P4 = (225 - I2(i,j)) / 255 * 2 * prop4;
                P5 = (225 - I2(i,j)) / 255 * 2 * prop5;

                    if rand < P4
                        flag = 1;
                        cells(i,j,5) = randsrc(1,1,[lTwo;pTwo]);
                        if rand < P5
                            cells(i,j,6) = randsrc(1,1,[lTwo;pTwo]);
                        end
                    end
                
                %周围相关
                if flag ~= 1
                    if rand < prop6
%     2  4  7
%     1     6
%     3  5  8

                        tt0 = [cells(ii,j,1) cells(ii,jj,1) cells(ii,jjj,1) cells(i,jj,1)...
                            cells(i,jjj,1) cells(iii,j,1) cells(iii,jjj,1) cells(iii,jj,1)];
                        tt1 = [cells(ii,j,4) cells(ii,jj,4) cells(ii,jjj,4) cells(i,jj,4)...
                            cells(i,jjj,4) cells(iii,j,4) cells(iii,jjj,4) cells(iii,jj,4)];
                        tt2 = [ cells(ii,j,5) cells(ii,jj,5) cells(ii,jjj,5) cells(i,jj,5)...
                            cells(i,jjj,5) cells(iii,j,5) cells(iii,jjj,5) cells(iii,jj,5)];
                        
                        %跨洲
                        for k = 1: 8
                            if tt0(k) ~= cells(i,j,1)
                                if rand < prop7
                                    cells(i,j,5) = tt1;
                                    cells(i,j,5) = 0;
                                end
                            end
                        end
                        %跨洋处理
                        buffer1 = [];
                        buffer2 = [];
                        n = 0;
                        if ~all(tt0)
                            findOcean(cells,i,j);
                        end
                       
                        
                        %跨海
                        [~,ss] = size(buffer2);
                        if  ss ~= 0 && rand < prop8^n
                            tt1 = [tt1 buffer2];
                        end
                        
                        tt = [tt1 tt2];
                        tt(tt==0)=[];%去除0
                        ttt = sortrows(tabulate(tt),2);
                        if ttt(1,1) ~= cells(i,j,4)
                            cells(i,j,5) = ttt(1,1);
                            if rand < prop9 && ttt(2,1) ~= cells(i,j,4) && ttt(2,1) ~= cells(i,j,5)
                                cells(i,j,6) = ttt(2,1);
                            end
                        else cells(i,j,5) = ttt(2,1);
                        end
                        
                        %扩散
                         P9 = (225 - I2(i,j)) / 255 * 2 * prop9;
                        if rand < P9
                            tt1 = [cells(ii,j,3) cells(ii,jj,3) cells(ii,jjj,3) cells(i,jj,3)...
                            cells(i,jjj,3) cells(iii,j,3) cells(iii,jjj,3) cells(iii,jj,3) cells(i,j,3)];
                            t = mean(tt1);
                            cells(ii,j,3) = t;
                            cells(ii,jj,3)= t;
                            cells(ii,jjj,3)= t;
                            cells(i,jj,3)= t;
                            cells(i,jjj,3)= t;
                            cells(iii,j,3)= t;
                            cells(iii,jjj,3)= t;
                            cells(iii,jj,3)= t;
                            cells(i,j,3)= t;
                        end
                        %迁移
                         P0 = (225 - I2(i,j)) / 255 * 2 * prop0;
                        if rand < P0
                            cells(i,j,3) = cells(i,j,3) - 5;
                            t = 0;
                            while t ==0
                                t1 = uint8(rand*x);
                                t2 = uint8(rand*y);
                                t = cells(t1,t2 ,1);
                            end
                            cells(t1,t2,3) = cells(t1,t2,3) +5;
                            if rand < 0.5
                                cells(t1,t2,4) = cells(i,j,4);
                                cells(t1,t2,5) = cells(i,j,5);
                                cells(t1,t2,6) = cells(i,j,6);
                            end
                        end
                        
                    end
                end
                        
                    
                
                %-------------------------------------
                
            end
        end
        global stepnumber
%输出图像------------------------------------------------------------------
        if stepnumber == 100
            CELLS = cells;
        end
        for i=1:x
            for j=1:y
                %图像处理
                
                %1
%                 if cells(i,j,1) == 0
%                     IMG(i,j,1) = 255;
%                     IMG(i,j,2) = 255;
%                     IMG(i,j,3) = 255;
%                 else
%                     IMG(i,j,1) = cells(i,j,3)*19;
%                     IMG(i,j,2) = cells(i,j,4)*19;
%                     IMG(i,j,3) = cells(i,j,5)*19;
%                 end
%                 
                %2
                if cells(i,j) ==0 
                    IMG(i,j) = 0;
                else 
                    IMG(i,j) = cells(i,j,4);
                end
            end
        end
        pause(0.001);
        IMG=uint8(IMG);
        imagesc(IMG);
        colorbar;
        axis equal;
        axis tight;
        %计步
        stepnumber=1+str2num(get(number,'string'));
        if stepnumber == 50
            peo =[0 0 0 0 0 0 0 0 0 0 0 0 0];%语言总人数
            peo1 = peo;%母语人数
            peo2 = peo;%2 3语言人数
            for i= 1:x
                for j = 1:y
                    if cells(i,j,4) ~= 0
                        peo(cells(i,j,4)) = peo(cells(i,j,4)) + cells(i,j,3);
                        peo1(cells(i,j,4)) = peo1(cells(i,j,4)) + cells(i,j,3);
                    end
                    if cells(i,j,5) ~= 0
                        peo(cells(i,j,5)) = peo(cells(i,j,5)) + cells(i,j,3);
                        peo2(cells(i,j,5)) = peo2(cells(i,j,5)) + cells(i,j,3);
                    end
                    if cells(i,j,6) ~= 0
                        peo(cells(i,j,6)) = peo(cells(i,j,6)) + cells(i,j,3);
                        peo2(cells(i,j,6)) = peo2(cells(i,j,6)) + cells(i,j,3);
                    end
                end
            end
            peo
            peo1
            peo2
        end
        set(number,'string',num2str(stepnumber));
    end
    if freeze==1
        run=0;
        freeze=0;
    end
    drawnow
end
%================================================================function



function findOcean(cells, i,j)
global buffer1;
global buffer2;
global n;
[x,y,~] = size(cells);
[~,ss] = size(buffer2);
if ss > 4  %至少获取5种
    return;
else
    n = n + 1;
    
    if i-1 > 0
        ii = i-1;
    else
        ii = x;
    end
    if j-1 > 0
        jj = j-1;
    else
        jj = y;
    end
    if i+1 < x+1
        iii = i+1;
    else
        iii = 1;
    end
    if j+1 < y+1
        jjj = j+1;
    else
        jjj = 1;
    end
                
    if cells(ii,j,1) == 0 
        buffer1 = [buffer1;ii,j];
    elseif cells(ii,j,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(ii,j,4) cells(ii,j,5)];
    end
    if cells(ii,jj,1) == 0 
        buffer1 = [buffer1;ii,jj];
    elseif cells(ii,jj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(ii,jj,4) cells(ii,jj,5)];
    end
    if cells(ii,jjj,1) == 0 
        buffer1 = [buffer1;ii,jjj];
    elseif cells(ii,jjj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(ii,jjj,4) cells(ii,jjj,5)];
    end
    if cells(i,jj,1) == 0 
        buffer1 = [buffer1;i,jj];
    elseif cells(i,jj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(i,jj,4) cells(i,jj,5)];
    end
    if cells(ii,j,1) == 0 
        buffer1 = [buffer1;ii,j];
    elseif cells(ii,j,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(i,j,4) cells(i,j,5)];
    end
    if cells(i,jjj,1) == 0 
        buffer1 = [buffer1;i,jjj];
    elseif cells(i,jjj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(i,jjj,4) cells(i,jjj,5)];
    end
    if cells(iii,jj,1) == 0 
        buffer1 = [buffer1;iii,jj];
    elseif cells(iii,jj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(iii,jj,4) cells(iii,jj,5)];
    end
    if cells(iii,j,1) == 0 
        buffer1 = [buffer1;iii,j];
    elseif cells(iii,j,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(iii,j,4) cells(iii,j,5)];
    end
    if cells(iii,jj,1) == 0 
        buffer1 = [buffer1;iii,jj];
    elseif cells(iii,jj,1) ~= cells (i,j,1)
        buffer2 = [buffer2 cells(iii,jj,4) cells(iii,jj,5)];
    end

    [L,~] = size(buffer1);
    for i = 1:L
        findOcean(cells,buffer1(L,1),buffer1(L,2));
    end

end


end


function a = nativLan(r,g,b,conti)
lAsia = [1 5 4 10 6 9];
pAsia = [0.461 0.097 0.232 0.050 0.097 0.063];
lEur = [3 2 7 8 13 12];
pEur = [0.159 0.101 0.027 0.281 0.257 0.175];
lSou = [7 2 3];
pSou = [0.317 0.583 0.1];
lAf = [5 7 3 11];
pAf = [0.253 0.027 0.012 0.708];
if r > 200 && r < 250 && g > 60 && g < 110 && b > 60 && b < 110
    a = 3;%英语
elseif  r < 80 && g > 30 && g < 140  && b > 220 
    a = 12;%法语
elseif r > 45 && r < 60 && g > 140 && g < 160 && b > 45 && b < 60
    a = 7;%葡萄牙
elseif r > 190 && r < 210 && g > 190 && g < 210 && b > 45 && b < 60
    a = 2;%西班牙
elseif r > 120 && r < 130 && g < 10 && b >  250
    a = 8;%俄语
elseif r < 10 && g > 250 &&   b < 10
    a = 5;%阿拉伯
elseif r > 50 && r < 100 && g > 200  && b > 150 && b < 200
    a = 1;%中文
elseif r > 100 && r < 150 && g > 30 && g < 80 && b < 10
    a = 13;%德语
elseif r > 180 && r < 220 && g > 80 && g < 120 && b > 180 && b < 220
    a = 4;%印度
elseif r > 250  && g > 120 && g < 160 && b > 40 && b < 70
    a = 6;%
else
    switch conti
        case 1
            a = randsrc(1,1,[lAf;pAf]);
        case 2
            a = randsrc(1,1,[lAsia;pAsia]);
        case 3
            a = randsrc(1,1,[lEur;pEur]);
        case 4
            a = 3;
        case 5
            a = 3;
        case 6
            a = randsrc(1,1,[lSou;pSou]);
        otherwise
            a = 0;
    end
end

end

