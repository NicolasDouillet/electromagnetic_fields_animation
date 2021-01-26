function [] = EB_field_propagation_animation()
% EB_dynamic_fields_animation : function to create
% an animation of a dynamic electromagnetic field.
%
% Author & support nicolas.douillet (at) free.fr, 2007-2021.


step = 0.05*pi;       % the signal step / resolution
phase = 2*pi:-step:0; % phase vector
nperiod = 1.5;        % the number of periods for the signals
time_lapse = 0.1;     % the animation time lapse

title_text = 'Electromagnetic field propagation (planar waves)';
filename = 'EB_dynamic_fields_animation.gif';
title_on = true;

% Display settings
h = figure;
set(h,'Position',get(0,'ScreenSize'));
set(gcf,'Color',[0 0 0]);       
axis tight manual;
az = 21; % azimut
el = 40; % elevation


for k = 1:length(phase)
    
    signal = EB_field(nperiod,step,phase(k));        
    
    pE = plot3(signal(1,:,1)',signal(2,:,1)',signal(3,:,1)','Color',[1 0 1],'Linewidth',2); hold on;
    pH = plot3(signal(1,:,2)',signal(2,:,2)',signal(3,:,2)','Color',[0 1 1],'Linewidth',2); hold on;    
    
    stem3(signal(1,1:2:end,1)',signal(2,1:2:end,1)',signal(3,1:2:end,1)','.','Color',[1 0 1],'Linewidth',2);
    stem(signal(1,1:2:end,2)',signal(2,1:2:end,2)','.','Color',[0 1 1],'Linewidth',2);        

    line([signal(1,1,1),signal(1,end,1)],[0,0],[0,0],'Color',[0 1 0]), hold on;
    line([signal(1,1,1),signal(1,1,1)],[0,1],[0,0],'Color',[0 1 0]), hold on;
    line([signal(1,1,1),signal(1,1,1)],[0,0],[0,1],'Color',[0 1 0]), hold on;
          
    legend([pE, pH],{'Electric field','Magnetic field'},'Location', 'NorthEast','Color',[0 0 0],'TextColor',[1 1 1],'FontSize',14,'EdgeColor',[1 1 1]);
    
    set(gca,'Color',[0 0 0]);   
    view([az,el]);
    grid off, axis off;
    
    if title_on
        title(title_text,'Color',[1 1 1],'FontSize',16);     
    end
    
    drawnow;
    
    frame = getframe(h);    
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    % Write to the .gif file
    if k == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',Inf,'DelayTime',time_lapse);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time_lapse);
    end
    
    clf;
    
end


end % EB_dynamic_fields_animation


function [signal] = EB_field(nperiod, step, phase)
%
% Author & support nicolas.douillet (at) free.fr, 2007-2021.


t = -nperiod*2*pi:step:nperiod*2*pi;
s = sin(t+phase);

signal = [t;zeros(1,length(t));s];

R = @(r)[1,0,0
         0,cos(r),-sin(r)
         0,sin(r),cos(r)];
     
signal(:,:,2) = R(-pi/2)*signal(:,:,1);


end