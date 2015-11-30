%Program for Color Image Segmentation

%Program Description
% The input color image will be coarsely represented using 25 bins.
% Coarse representation uses the spatial information from a Histogram based windowing process.
% K-Means is used to cluster the coarse image data.
%
%Parameters
% AJSinput  -   Input Color Image
% nBins     -   No. of Bins for coarse representation
% winSize   -   Window size for histogram processing
% nClass    -   No. of classes
% AJSoutput -   Output Segmented Image


function AJSoutput = AJSImgSeg(AJSinput, nBins, winSize, nClass)

s = size(AJSinput);

NbParam = nBins * nBins * nBins;
divis = 256 / nBins ;

s=size(AJSinput);
N=winSize;

n=(N-1)/2;
r=s(1)+2*n;
c=s(2)+2*n;
double temp(r,c,3);
temp=zeros(r,c,3);out=zeros(r,c,3);
coarseImg = zeros(r,c);
TabLabel = zeros(1,NbParam);
inrImg = rgb2gray(AJSinput);

temp((n+1):(end-n),(n+1):(end-n),1)=AJSinput(:,:,1);
temp((n+1):(end-n),(n+1):(end-n),2)=AJSinput(:,:,2);
temp((n+1):(end-n),(n+1):(end-n),3)=AJSinput(:,:,3);

temp_color = temp;

for x=n+1:s(1)+n
    for y=n+1:s(2)+n
        e=1;
        for k=x-n:x+n
            f=1;
            for l=y-n:y+n
                mat(e,f,1)=temp(k,l,1);
                mat(e,f,2)=temp(k,l,2);
                mat(e,f,3)=temp(k,l,3);
                f=f+1;
            end
            e=e+1;
        end

        sum_lab = 0;
        for i = 1 : winSize
            for j = 1 : winSize
                lab = floor(mat(i,j,1)/divis)*(nBins*nBins);
                lab = lab + floor(mat(i,j,2)/divis)*(nBins);
                lab = lab + floor(mat(i,j,3)/divis);
                lab = lab + 1;
                TabLabel(lab) = TabLabel(lab) + 1;
                sum_lab = sum_lab + lab;
            end
        end
        coarseImg(x,y) = floor(sum_lab / (winSize * winSize));

    end
end
trunCoarseImg(:,:) = coarseImg((n+1):(end-n),(n+1):(end-n));

tempVar = trunCoarseImg(:,:);
inImg_1D = double(tempVar(:));
fusedMap = kmeans(inImg_1D,nClass, 'EmptyAction', 'singleton');
fusedMapShow = uint8(fusedMap.*(255/nClass));
AJSoutput = reshape(fusedMapShow,s(1),s(2));
