function IMPATH=showpath(i,j)

if i==1
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/beach/beach';
elseif i==2
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/agricultural/agricultural';
elseif i==3
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/buildings/buildings';
elseif i==4
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/forest/forest%2.2d.tif';
elseif i==5
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/river/river%2.2d.tif';
elseif i==6
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/harbor/harbor';
elseif i==7
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/denseresidential/denseresidential';
elseif i==8
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/sparseresidential/sparseresidential';
elseif i==9
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/freeway/freeway';
elseif i==10
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/airplane/airplane';
elseif i==11
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/baseballdiamond/baseballdiamond';
elseif i==12
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/chaparral/chaparral';
elseif i==13
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/golfcourse/golfcourse';
elseif i==14
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/mobilehomepark/mobilehomepark';
elseif i==15
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/intersection/intersection';
elseif i==16
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/mediumresidential/mediumresidential';
elseif i==17
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/overpass/overpass';
elseif i==18
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/parkinglot/parkinglot';
elseif i==19
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/runway/runway';
elseif i==20
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/storagetanks/storagetanks';
elseif i==21
    A='C:/Users/SoumyaShubhraGhosh/Pictures/Images/tenniscourt/tenniscourt';
end

IMNUM = sprintf('%2.2d.tif',j-1);
IMPATH = strcat(A,IMNUM);

end
