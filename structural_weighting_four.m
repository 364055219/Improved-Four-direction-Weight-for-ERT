clear; clc;
%% input guided image
image=double(imread('gui_img.jpg'));
[n1 n2]=size(image);
figure(1)
imshow(image,[]);
%% import model data
load (['s1']); % semblance matrix of guided image (The s1 in the manuscript)
load (['s2']); % semblance matrix of guided image (The s2 in the manuscript)
load (['v']); % eigenvector matrix of pixels (The v and u in the manuscript)
load (['ev']); % eigenvalue of pixels (The λv and λu in the manuscript)
load (['Coord_y']);% Vertical mesh node center
load (['inv_mesh_coords']);% Inverse mesh coordinates
%% input calculation parameters
threshold_discontinuity=0.93;
% Smoothing weight value
w_max=10;
w_con=1;
w_min=0.1;
%% Tensor ellipse control parameters
r =0.3;
nt =100;
usamp=1;
marker_size=5;
dt = 2.0*pi/(nt-1);
ft = 0;
hstep=0.03;
plot_ellipses=1;
%% Model parameter transformation
[nelem_sizeY,tempxy]=size(temp13_y);
[nelem_sizeX1,temyx]=size(unique(inv_mesh_coords(:,1)));
nelem_sizeX=nelem_sizeX1-1;
x_max_right_btm=max(inv_mesh_coords(:,1));
y_min_left_top=max(abs(inv_mesh_coords(:,2)));
Dwidth=x_max_right_btm/nelem_sizeX;
for i=1:nelem_sizeY
    for j=1:nelem_sizeX
        param_x((i-1)*nelem_sizeX+j,1)=Dwidth*j;
    end
end
i_mesh_cords=unique(abs(inv_mesh_coords(:,2)));
Y_nelem_bottom_coords=i_mesh_cords(2:nelem_sizeY+1);
Y_nelem_center_coords=flipud(abs(temp13_y));
Ddepth(1,1)=Y_nelem_bottom_coords(1);
for i=2:nelem_sizeY
    Ddepth(i,1)=Y_nelem_bottom_coords(i,1)-Y_nelem_bottom_coords(i-1,1);
end
for i=1:nelem_sizeY
    param_y((i-1)*nelem_sizeX+1:(i*nelem_sizeX),1)=Y_nelem_bottom_coords(i);
end
X=ceil((param_x)*(n2/x_max_right_btm));
Y=ceil((param_y)*(n1/y_min_left_top));
X_s2=ceil((param_x-1)*(n2/x_max_right_btm));
X(find(X==0))=1;
Y(find(Y==0))=1;
X(X==n2)=n2-1;
Y(find(Y==n1))=n1-1;
X(X==n2+1)=n2-1;
Y(find(Y==n1+1))=n1-1;
YY=reshape(Y,nelem_sizeX,nelem_sizeY)';
%% Graph of semblance s2 
figure(2)
subplot(1,1,1)
xx=[0 x_max_right_btm];
yy=[0 y_min_left_top];
imagesc(xx,yy,s2);
axis image
yt=unique(inv_mesh_coords(:,1));
xt=unique(abs(inv_mesh_coords(:,2)));
axis on
set(gca,'XTick',yt)
set(gca,'YTick',xt')
grid on
set(gca,'gridcolor','r')
colorbar
caxis([0.8,threshold_discontinuity])
hold on
%% Dimensions of the elliptic tensor in the direction of the four axes
c=0;
n_vu=0;
x1=zeros(nt,1);
x2=zeros(nt,1);
XXX=unique(param_x);
XXXX=unique(X);
YYYY=unique(Y);
for i2=1:usamp:nelem_sizeY
    for i1=1:usamp:nelem_sizeX
        n_vu=n_vu+1;
        k1=XXXX(i1);
        k2=YYYY(i2);
        s(:,n_vu) = ev(:,k2,k1);
        v1 = v(1,n_vu);
        v2 = v(2,n_vu);
        du = s(1,n_vu);
        dv = s(2,n_vu);
        sdu(i2,i1)=abs(du);
        sdv(i2,i1)=abs(dv);
        vi1=XXX(i1)-(0.5*Dwidth);
        vi2=Y_nelem_center_coords(i2);
        a = r*sqrt(dv);
        b = r*sqrt(du);
        % Tensor ellipsoidal point data logging
        for it=1:nt
            c=c+1;
            t = ft+(it-1)*dt;
            cost = cos(t);
            sint = sin(t);
            x1(c) = vi1 + a*cost*v1 - b*sint*v2;
            x2(c) = vi2 + a*cost*v2 + b*sint*v1;
        end
        ax1=a*cos(atan(v2/v1))*v1 - b*sin(atan(v2/v1))*v2;
        ay1=a*cos(atan(v2/v1))*v2 + b*sin(atan(v2/v1))*v1;
        ab1(i2,i1)=((ay1)^2+(ax1)^2)^(1/2);
        ax2=a*cos(pi/2+atan(v2/v1))*v1 - b*sin(pi/2+atan(v2/v1))*v2;
        ay2=a*cos(pi/2+atan(v2/v1))*v2 + b*sin(pi/2+atan(v2/v1))*v1;
        ab2(i2,i1)=((ay2)^2+(ax2)^2)^(1/2);
        abx1=a*cos(atan(v2/v1)-atan(Ddepth(i2)/Dwidth))*v1 - b*sin(atan(v2/v1)-atan(Ddepth(i2)/Dwidth))*v2;
        aby1=a*cos(atan(v2/v1)-atan(Ddepth(i2)/Dwidth))*v2 + b*sin(atan(v2/v1)-atan(Ddepth(i2)/Dwidth))*v1;
        ab3(i2,i1)=((aby1)^2+(abx1)^2)^(1/2);
        abx2=a*cos(atan(v2/v1)+atan(Ddepth(i2)/Dwidth))*v1 - b*sin(atan(v2/v1)+atan(Ddepth(i2)/Dwidth))*v2;
        aby2=a*cos(atan(v2/v1)+atan(Ddepth(i2)/Dwidth))*v2 + b*sin(atan(v2/v1)+atan(Ddepth(i2)/Dwidth))*v1;
        ab4(i2,i1)=((aby2)^2+(abx2)^2)^(1/2);
        abz(i2,i1)=ab1(i2,i1)+ab2(i2,i1)+ab3(i2,i1)+ab4(i2,i1);        
        Wb1(i2,i1)=(4*ab1(i2,i1)/abz(i2,i1));
        Wb2(i2,i1)=(4*ab2(i2,i1)/abz(i2,i1));
        Wb3(i2,i1)=(4*ab3(i2,i1)/abz(i2,i1));
        Wb4(i2,i1)=(4*ab4(i2,i1)/abz(i2,i1));        
    end
end
%% Tensor ellipse diagram
if plot_ellipses==1
    subplot(1,1,1)
    plot(x1,x2,'.','MarkerSize',marker_size)
    axis ij
    axis equal
    xlim([0 max(x_max_right_btm)])
    ylim([0 max(y_min_left_top)])
    hold on
else
    Mts=[x1 x2];
    save('ellipses.dat','Mts','-ascii')
end
%% Handling of model boundary cell weights
for i2=1:nelem_sizeY
    for i1=1:nelem_sizeX
        Wb1(nelem_sizeY,i1)=Wb1(nelem_sizeY-1,i1);
        Wb2(nelem_sizeY,i1)=Wb2(nelem_sizeY-1,i1);
        Wb3(nelem_sizeY,i1)=Wb3(nelem_sizeY-1,i1);
        Wb4(nelem_sizeY,i1)=Wb4(nelem_sizeY-1,i1);
    end
end
for i2=1:nelem_sizeY
    for i1=1:nelem_sizeX
        Wb1(i2,nelem_sizeX)=Wb1(i2,nelem_sizeX-1);
        Wb2(i2,nelem_sizeX)=Wb2(i2,nelem_sizeX-1);
        Wb3(i2,nelem_sizeX)=Wb3(i2,nelem_sizeX-1);
        Wb4(i2,nelem_sizeX)=Wb4(i2,nelem_sizeX-1);
    end
end
wbn1=flipud(Wb1);
wbn2=flipud(Wb2);
wbn3=flipud(Wb3);
wbn4=flipud(Wb4);
wb1=ones(size(Wb1));
wb2=wb1;
wb3=wb1;
wb4=wb1;
% Weight initialization
w1=eye(nelem_sizeY*nelem_sizeX);
w2=w1;
w3=w1;
w4=w1;
%% Structural unit identification
Edge=zeros(n1,n2);
Coherence=Edge;
JJ=zeros(size(Wb1));
JJn=zeros(size(Wb1));
for n=1:nelem_sizeX  
    [A,B]=sort(s2(:,X_s2(n)));
    if min(A-threshold_discontinuity)<0
        maxA=max(A(A<=threshold_discontinuity,1));
        J=find(A==maxA);
        J=unique(J);
        Edge(:,X_s2(n))=[B(1:J);zeros((n1-J),1)]; 
        J=unique(Edge(:,X_s2(n)));
        for i=2:length(J)
            [x,j]=min(abs(J(i)-YY(:,n)));
            J(i)=j;
        end 
        J = unique(J);
        if length(J)>=3
            for l=2:length(J)-1
                if J(l)==J(l+1)-1
                    J(l+1)=0;
                end
            end
        end 
        if length(J)>=2
            J=unique(J);
            JJ(:,n)=[J(1:length(J));zeros((nelem_sizeY-length(J)),1)];            
            for jn=1:nelem_sizeY
                if JJ(jn,n)>0
                    JJn(JJ(jn,n),n)=JJ(jn,n);
                end
            end
            for l=2:length(J)
                J(l)=nelem_sizeY+1-J(l);
            end
        end
%% Weight assignment
        for k=2:length(J)
            if J(k)>1
                WB=[wbn1(J(k),n) wbn2(J(k),n) wbn3(J(k),n) wbn4(J(k),n)];
                [maWB,naWB]=max(WB);
                [miWB,niWB]=min(WB);
                i=J(k)+(n-1)*nelem_sizeY;
                if naWB==1
                    wb1(J(k),n)=w_max;
                    wb2(J(k),n)=w_min;
                    wb3(J(k),n)=w_min;
                    wb4(J(k),n)=w_max;                    
                    wb1(J(k)-1,n)=w_max;
                    wb2(J(k)-1,n)=w_max;
                    wb3(J(k)-1,n)=w_max;
                    wb4(J(k)-1,n)=w_min;                    
                    
                    w1(i,i)=wb1(J(k),n);
                    w2(i,i)=wb2(J(k),n);
                    w3(i,i)=wb3(J(k),n);
                    w4(i,i)=wb4(J(k),n);
                    w1(i-1,i-1)=wb1(J(k)-1,n);
                    w2(i-1,i-1)=wb2(J(k)-1,n);
                    w3(i-1,i-1)=wb3(J(k)-1,n);
                    w4(i-1,i-1)=wb4(J(k)-1,n); 
                    
                elseif naWB==2
                    wb1(J(k),n)=w_min;
                    wb2(J(k),n)=w_max;
                    wb3(J(k),n)=w_min;
                    wb4(J(k),n)=w_min;
                    
                    w1(i,i)=wb1(J(k),n);
                    w2(i,i)=wb2(J(k),n);
                    w3(i,i)=wb3(J(k),n);
                    w4(i,i)=wb4(J(k),n);
                    
                elseif naWB==3
                    wb1(J(k),n)=w_max;
                    wb2(J(k),n)=w_min;
                    wb3(J(k),n)=w_max;
                    wb4(J(k),n)=w_max;                    
                    wb1(J(k)+1,n)=w_max;
                    wb2(J(k)+1,n)=w_max;
                    wb3(J(k)+1,n)=w_max;
                    wb4(J(k)+1,n)=w_max;                    
                    wb1(J(k)-1,n)=w_min;
                    wb2(J(k)-1,n)=w_max;
                    wb3(J(k)-1,n)=w_max;
                    wb4(J(k)-1,n)=w_min;                    
                    wb1(J(k)-2,n)=w_max;
                    wb2(J(k)-2,n)=w_max;
                    wb3(J(k)-2,n)=w_max;
                    wb4(J(k)-2,n)=w_min;
                    
                    w1(i,i)=wb1(J(k),n);
                    w2(i,i)=wb2(J(k),n);
                    w3(i,i)=wb3(J(k),n);
                    w4(i,i)=wb4(J(k),n);                    
                    w1(i-1,i-1)=wb1(J(k)-1,n);
                    w2(i-1,i-1)=wb2(J(k)-1,n);
                    w3(i-1,i-1)=wb3(J(k)-1,n);
                    w4(i-1,i-1)=wb4(J(k)-1,n);                    
                    w1(i-2,i-2)=wb1(J(k)-2,n);
                    w2(i-2,i-2)=wb2(J(k)-2,n);
                    w3(i-2,i-2)=wb3(J(k)-2,n);
                    w4(i-2,i-2)=wb4(J(k)-2,n);                                  
                    w1(i+1,i+1)=wb1(J(k)+1,n);
                    w2(i+1,i+1)=wb2(J(k)+1,n);
                    w3(i+1,i+1)=wb3(J(k)+1,n);
                    w4(i+1,i+1)=wb4(J(k)+1,n);
                    
                elseif naWB==4
                    wb1(J(k),n)=w_min;
                    wb2(J(k),n)=w_min;
                    wb3(J(k),n)=w_min;
                    wb4(J(k),n)=w_max;                    
                    wb1(J(k)+1,n)=w_max;
                    wb2(J(k)+1,n)=w_max;
                    wb3(J(k)+1,n)=w_min;
                    wb4(J(k)+1,n)=w_max;                    
                    wb1(J(k)+2,n)=w_max;
                    wb2(J(k)+2,n)=w_max;
                    wb3(J(k)+2,n)=w_max;
                    wb4(J(k)+2,n)=w_con;                    
                    wb1(J(k)-1,n)=w_max;
                    wb2(J(k)-1,n)=w_max;
                    wb3(J(k)-1,n)=w_max;
                    wb4(J(k)-1,n)=w_max;
                    
                    w1(i,i)=wb1(J(k),n);
                    w2(i,i)=wb2(J(k),n);
                    w3(i,i)=wb3(J(k),n);
                    w4(i,i)=wb4(J(k),n);                    
                    w1(i-1,i-1)=wb1(J(k)-1,n);
                    w2(i-1,i-1)=wb2(J(k)-1,n);
                    w3(i-1,i-1)=wb3(J(k)-1,n);
                    w4(i-1,i-1)=wb4(J(k)-1,n);                    
                    w1(i+1,i+1)=wb1(J(k)+1,n);
                    w2(i+1,i+1)=wb2(J(k)+1,n);
                    w3(i+1,i+1)=wb3(J(k)+1,n);
                    w4(i+1,i+1)=wb4(J(k)+1,n);                    
                    w1(i+2,i+2)=wb1(J(k)+2,n);
                    w2(i+2,i+2)=wb2(J(k)+2,n);
                    w3(i+2,i+2)=wb3(J(k)+2,n);
                    w4(i+2,i+2)=wb4(J(k)+2,n);
                end
            end
            if J(k)==1
                i=2+(n-1)*nelem_sizeY;
                w1(i,i)=wb1(2,n);
                w2(i,i)=wb2(2,n);
                w3(i,i)=wb3(2,n);
                w4(i,i)=wb4(2,n);
            end
        end
    end
end
save('w1','w1');
save('w2','w2');
save('w3','w3');
save('w4','w4');
