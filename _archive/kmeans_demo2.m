% The following is the implementation of the k-means clustering algorithm
% Questions regarding the code may be directed to:
% orramirezba@ittepic.edu.mx
clc; clear all; close all; % clear memory and command window
%% Data of the algorithm
k=4; % Number of clusters
iter=15; % Number of iterations
%% Generate random data points 
n=75; % number of samples or points
rx=10*rand(n,1); % vector of random data x
ry=10*rand(n,1); % vector of random data y
%% Initial values of the centroids
centroidsx=rx( ceil(rand(k,1)*size(rx,1)) ,:); % initial cluster centers x
centroidsy=ry( ceil(rand(k,1)*size(ry,1)) ,:); % initial cluster centers y
%% Iterative process
for p=1:iter
    for i=1:n
        for j=1:k
            if p==1
                diste(i,j)=sqrt(((rx(i))-(centroidsx(j)))^2+((ry(i))-(centroidsy(j)))^2);
            % the sample of the jth centroid
            else
                diste(i,j)=sqrt(((rx(i))-(Cclustx(j)))^2+((ry(i))-(Cclusty(j)))^2);
            end
        end
        % Define clusters
        [minidist, CN] = min(diste(i,1:k)); % minimum distance and the
        % cluster which the sample belongs to
        Distance(p,i)=minidist; Cln(p,i)=CN;
    end
    % Recompute the clusters center
    for q=1:k
        PC=(Cln(p,:)==q); % Position of the points of the cluster
        Cpoints(q,:)=PC; % Points of the cluster
        Cclustx(q,:)=mean(rx(PC)); % New cluster centers in x
        Cclusty(q,:)=mean(ry(PC)); % New cluster centers in y
    end
    SCCx(p,:)=Cclustx; % center of the cluster at each iteration in x
    SCCy(p,:)=Cclusty; % center of the cluster at each iteration in y
    CPP(p,:,:)=Cpoints; % points of the cluster at each iteration
end
%% Plot of the movements of the centroids and clusters
CV= 'o*+s^v.db+c+m+k+yorobocomokoysrsbscsmsksy'; % Color Vector
for p=1:iter+1
    figure (1)
    if p==1
        plot(rx,ry,'o','LineWidth',1.5); hold on; plot(centroidsx,centroidsy,'*k','LineWidth',6.5);
        hold off
    else
        for i=1:k
        plot(rx(CPP(p-1,i,:)),ry(CPP(p-1,i,:)),CV(i),'LineWidth',2); % Plot points with determined color and shape
        hold on
        end
        plot(SCCx(p-1,:),SCCy(p-1,:),'*k','LineWidth',6); hold off
    end
    grid on
    pause(0.8)
end