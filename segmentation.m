function[robot_xy,target_xy,map] = segmentation(path,thr1,thr2,thr3)

% function[robot_xy,target_xy,map] = segmentation(path,thr1,thr2,thr3)
%
% Funkcja wczytuj¹ca obraz z zadanej œcie¿ki (path) i wykonuj¹ca operacje
% na obrazie w celu uzyskania koordynatów robota, celu jego jazdy oraz
% macierzy zawieraj¹cej wszystkie przeszkody.

img = rgb2gray(imread(path));

se = strel('disk',4);

im_robot = im2bw(img,thr2);
im_target = im2bw(img,thr1);
im_target = imerode(im_target,se);
im_obst = im2bw(img,thr3);

im_obst = imclose(im_obst,se);


im_obst = imcomplement(imcomplement(im_obst) - imcomplement(im_target));
im_target = imcomplement(im_target);




[label,num] = bwlabel(im_robot,4);
% Sprawdzenie czy zosta³y wykryte jakiekolwiek obiekty
            if(num)
                wlasnosci_obiektu  = regionprops(label, 'centroid','Orientation');
                robot_xy = cat(1, wlasnosci_obiektu.Centroid);
            else
                fprintf('Nie wykryto robota na obrazie')
                return;
               
            end
            
[label,num] = bwlabel(im_target,4);
% Sprawdzenie czy zosta³y wykryte jakiekolwiek obiekty
            if(num)
                wlasnosci_obiektu  = regionprops(label, 'centroid','Orientation');
                target_xy = cat(1, wlasnosci_obiektu.Centroid);
            else
                fprintf('Nie wykryto celu ruchu na obrazie')
               return;
            end
            
            map = im_obst;
end