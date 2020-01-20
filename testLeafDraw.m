% test drawLeaf
clear all;

lum = 128;
width = 300;
apex = 140;
height = 150;

x = [1,apex,width;1,apex,width];
y = [1,height,1;1,-height,1];

coords = drawLeaf(x,y);

texMatTop = zeros(height,width);
texMatBottom = zeros(height,width);

for i = 1:width
    
    texMatTop(coords(2,i):size(texMatTop,1),i) = lum;
    
end





