path(path,'setup')
path(path,'..')
path(path,'../..')
colors = {'b','g','m','b','g','m'}

% Loops through each of the dataset examples considered in the text 
for ss = [1:4 7]
    figure(ss),clf;
    if ss == 2
        h1 = figure(2),clf;
    end
    subplot(2,10,[1:6 11:16])
    set(gcf,'Position',[20 100 800 500])
    hold on;
    % Loads in the data and sets graph parameters (axis range, etc)
    switch(ss)
        case 1
            'mpx'
            load('data\script011014_mpx_spx')
            x_arr = m1_arr;
            y_arr = m2_arr;
            cont_data = cont_mpx;
            MLres = MLres_mpx;
            ci1D = ci1D_mpx;
            xr = [.001 .8];
            yr = [0 .8];
            loc = 'NorthWest'
            xlab = 'R - Primary';
            ylab = 'R - Secondary';
            best_mm = 5;
        case 2
            'spx'
            load('data\script011014_mpx_spx')
            x_arr = s1_arr;
            y_arr = s2_arr;
            cont_data = cont_spx;
            MLres = MLres_spx;
            ci1D = ci1D_spx;
            xr = [0.1 6];
            yr = [0 6];
            loc = 'East'
            xlab = 'R - Primary';
            ylab = 'R - Secondary';
            best_mm = 1;
        case 3
            'msls'
            load('data\script011014_msls')
            x_arr = ms1_arr;
            y_arr = ms2_arr;
            cont_data = cont_msls;
            MLres = MLres_msls;
            ci1D = ci1D_msls;
            xr = [.31 1.3];
            yr = [.3 1.3];
            loc = 'SouthEast'
            xlab = 'R - United States';
            ylab = 'R - Canada';
            best_mm = 2;
        case 4
            'mpx_ps'
            load('data\script052314_mpx_ps')
            x_arr = mp1_arr;
            y_arr = mp2_arr;
            cont_data = cont_mpx_ps;
            MLres = MLres_mpx_ps;
            ci1D = ci1D_mpx_ps;
            xr = [0.05 0.6];
            yr = [0.05 0.6];
            loc = 'SouthEast'
            xlab = 'R - Animal to human';
            ylab = 'R - Human to human';
            best_mm = 3;
        case 5
            'mers_time'
            load('data\script032814_mers')
            x_arr = mt1_arr;
            y_arr = mt2_arr;
            cont_data = cont_mers_time;
            MLres = MLres_mers_time;
            ci1D = ci1D_mers_time;
            xr = [0.01 3];
            yr = [0 3];
            loc = 'North'
            xlab = 'R - July 2012';
            ylab = 'R - July 2013';
            best_mm = 6;
        case 6
            'mers_sars'
            load('data\script032814_mers')
            x_arr = ms1_arr;
            y_arr = ms2_arr;
            cont_data = cont_mers_sars;
            MLres = MLres_mers_sars;
            ci1D = ci1D_mers_sars;
            xr = [0.01 2.6];
            yr = [0 2.6];
            loc = 'SouthEast'
            xlab = 'R - MERS';
            ylab = 'R - SARS';
            best_mm = 5; % Not set yet
        case 7
            'mers_cauch'
            load('data\script032814_mers')
            x_arr = me1_arr;
            y_arr = me2_arr;
            cont_data = cont_mers_cauch;
            MLres = MLres_mers_cauch;
            ci1D = ci1D_mers_cauch;
            xr = [0.01 2];
            yr = [0 2];
            loc = 'East'
            xlab = 'R - Before June 2013';
            ylab = 'R - After June 2013';
            best_mm = 3; 
    end
    for mm = 1:3
        plot([-1 -2],[-1 -2],'-','color',colors{mm},'LineWidth',3)
    end
    if ss == 1
        plot([-9 -8],[-9 -8],'r','LineWidth',3)
    end
    meth_str = {'None','$k_A=k_B$','$k_A=k_B=1$','$R_A = R_B$','$R_A = R_B, k_A=k_B$','$R_A = R_B, k_A=k_B=1$'};
    best_L= 2*MLres(best_mm,5);
    npar = [4 3 2 3 2 1];
    
    % Prints out the model comparison results in a format that is easy to
    % incorprate into latex
    for mm = [6 5 3 4 2 1]
        mtext = round(10*MLres(mm,:))/10;
        mtext(6) = -2*MLres(mm,5)+best_L+2*npar(mm)-2*npar(best_mm);
        mtext(6) = round(10*mtext(6))/10;
        strcat([meth_str{mm},' & ',num2str(npar(mm)),' & ',num2str(mtext(1)),' & ',num2str(mtext(2)),' & ',num2str(mtext(3)),' & ',num2str(mtext(4)),' & ',num2str(mtext(5)),' & ',num2str(mtext(6))])
    end
    plot(xr,xr,'--','Color',[.5 .5 .5],'LineWidth',3)
    %Plots MLE for unconstrained model
    for mm = [1]
        plot(MLres(mm,1),MLres(mm,3),'.','color','k','MarkerSize',24)
    end
    %Plots contours
    for mm = 1:3
        contour(x_arr,y_arr,squeeze(cont_data(mm,:,:))',[-3 -3],'color',colors{mm},'LineWidth',3)
    end
    %Plots CIs for the three models in wihch the R is constant
    for mm = 4:6
        fi = find(ci1D(mm-2,:)> -1.92,1);
        ll = (ci1D(1,fi-1)*(ci1D(mm-2,fi)+1.92)-ci1D(1,fi)*(ci1D(mm-2,fi-1)+1.92))/(ci1D(mm-2,fi)-ci1D(mm-2,fi-1));
        li = fi+ find(ci1D(mm-2,fi+1:end)< -1.92,1);
        ul = (ci1D(1,li-1)*(ci1D(mm-2,li)+1.92)-ci1D(1,li)*(ci1D(mm-2,li-1)+1.92))/(ci1D(mm-2,li)-ci1D(mm-2,li-1));
        ci_arr = [ll MLres(mm,1) ul]
        plot(ci_arr,ci_arr+(mm-5)*mean(xr+yr)*.02','--','color',colors{mm},'Linewidth',3)
        plot(ci_arr(2),ci_arr(2)+(mm-5)*mean(xr+yr)*.02','.','color',colors{mm},'MarkerSize',24)
    end
    set(gca,'FontSize',16)
    xlabel(xlab)
    ylabel(ylab)
    xlim(xr)
    ylim(yr)
    labelg(.2,0.05,1,16)
    
    % This section is just for the random network model as applied ot the
    % monkeypox data
    if ss == 1
        plot(net_res_mpx(:,1),net_res_mpx(:,1).*(1+1./net_res_mpx(:,2)),':','Color',[.5 .5 .5],'LineWidth',3)
        plot(net_r0k(1),net_r0k(1)*(1+1/net_r0k(2)),'.','color','r','MarkerSize',24)
        xl = round(net_r0k_1Dmin(:,1)*100);
        xu = round(net_r0k_1Dmax(:,1)*100);
        plot(net_res_mpx(xl:xu,1),net_res_mpx(xl:xu,1).*(1+1./net_res_mpx(xl:xu,2)),'r','LineWidth',3)
        legend({'k_A \neq k_B','k_A = k_B','k_A = k_B = 1','Network model'},'Location',loc,'FontSize',12)
%        legend({'k_A and k_B inferred separately','k_A = k_B inferred as one parameter','k_A = k_B = 1 assumed','Network model'},'Location',loc,'FontSize',10)
        'Network L'
        MLres(1,5)+net_r0k(3)
        'Network AIC'
        2*(MLres(1,5)+net_r0k(3)-MLres(best_mm,5))
    else
        legend({'k_A \neq k_B','k_A = k_B','k_A = k_B = 1'},'Location',loc,'FontSize',12)
%         legend({'k_A and k_B inferred separately','k_A = k_B inferred as one parameter','k_A = k_B = 1 assumed'},'Location',loc,'FontSize',10)
    end
    legend boxoff

    % This determines the AIC scores adn plots the best model fits on the
    % right of the figure
    call_str={'mpx_primsec','spx','msls','mpx_ps','','','mers'}
    aic_arr = -2*MLres(1:6,5)'+2*npar
    [aic1,i1]=min(aic_arr(1:3));
    [aic2,i2]=min(aic_arr(4:6));
    if (aic1 + 2 < aic2)
        i_best = i1;
    else
        i_best = i2+3;
    end
    disp_bestdata051014(call_str{ss},i_best);
end



%%
% This section address the effectiveness of control of secondary
% transmission of smallpox.  It makes the inset of the figure for smallpox
% transmission

'spx'
load('data\script011014_mpx_spx')
x_arr = s1_arr;
y_arr = s2_arr;
cont_data = cont_spx;
MLres = MLres_spx;
ci1D = ci1D_spx;
xr = [0.1 8];
yr = [0 1];
loc = 'NorthEast'
xlab = 'R - Primary';
ylab = 'Control';

h2 = figure(5),clf;
set(h2,'position',[360 278 560 420]);
cont_data = contour(x_arr,y_arr,squeeze(cont_data(1,:,:))',[-3 -3]);
cont_data = cont_data(:,2:end);
figure(5),clf;
hold on;

plot(MLres(1,1),MLres(1,3)/MLres(1,1),'b.','MarkerSize',24)
% contour(x_arr,y_arr,squeeze(cont_data(mm,:,:))',[-3 -3],'color',colors{mm},'LineWidth',3)
plot(cont_data(1,:),cont_data(2,:)./cont_data(1,:),'b','LineWidth',3)
set(gca,'FontSize',14)
xlabel(xlab)
ylabel(ylab)
xlim(xr)
ylim(yr)

inset_spx(h1,h2)
figure(2), close
figure(5), close

%%
% Saves all the figures
figure(1)
savepdf('Figs/mpx052314')
figure(12)
savepdf('Figs/spx052314')
figure(3)
savepdf('Figs/msls052314')
figure(4)
savepdf('Figs/mpx_ps052314')
figure(7)
savepdf('Figs/mers_cauch052314')
