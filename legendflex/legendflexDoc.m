%% An Overview of legendflex.m
% This document gives an overview of the legendflex.m function, along with
% several examples demonstrating its use.

% %%
% % Rather than use location strings like legend (e.g. 'northeast'),
% % legendflex uses a combination of anchor points and an offset to position
% % the legend.  The anchor points refer to the corners and centers of each
% % side of the box surrounding a reference object and the legend itself;
% % they can be refered to either as numbers (1-8, clockwise from northwest
% % corner) or strings ('nw', 'n', 'ne', 'e', 'se', 's', 'sw', 'w').  The
% % position of the legend is determined by these two points and the distance
% % between them, defined in the 'buffer' variable, which by default is
% % measured in pixels.  So the combination of
% % 
% %  (..., 'ref', gca, 'anchor', [3 3], 'buffer', [-10 -10])
% %
% % means that you want the northeast corner of the legend to be aligned with
% % the northeast corner of the current axis, but 10 pixels to the left and
% % down.  The following anchor/buffer combinations can be used to more or
% % less replicate the legend command locations:
% %
% % <html>
% % <table>
% % <tr><td>Specifier            </td><td>   Anchor  </td><td>   Buffer
% % </td></tr>
% % <tr><td>north                </td><td>   [2 2]   </td><td>   [0 -10]
% % </td></tr>
% % <tr><td>south                </td><td>   [6 6]   </td><td>   [0 10]
% % </td></tr>
% % <tr><td>east                 </td><td>   [4 4]   </td><td>   [-10 0]
% % </td></tr>
% % <tr><td>west                 </td><td>   [8 8]   </td><td>   [10 0]
% % </td></tr>
% % <tr><td>northeast            </td><td>   [3 3]   </td><td>   [-10 -10]
% % </td></tr>
% % <tr><td>northwest            </td><td>   [1 1]   </td><td>   [10 -10]
% % </td></tr>
% % <tr><td>southeast            </td><td>   [5 5]   </td><td>   [-10 10]
% % </td></tr>
% % <tr><td>southwest            </td><td>   [7 7]   </td><td>   [10 10]
% % </td></tr>
% % <tr><td>northoutside*        </td><td>   [2 6]   </td><td>   [0 10]
% % </td></tr>
% % <tr><td>southoutside*        </td><td>   [6 2]   </td><td>   [0 -10]
% % </td></tr>
% % <tr><td>eastoutside*         </td><td>   [3 8]   </td><td>   [10 0]
% % </td></tr>
% % <tr><td>westoutside*         </td><td>   [8 3]   </td><td>   [-10 0]
% % </td></tr>
% % <tr><td>northeastoutside*    </td><td>   [3 1]   </td><td>   [10 0]
% % </td></tr>
% % <tr><td>northwestoutside*    </td><td>   [1 3]   </td><td>   [-10 0]
% % </td></tr>
% % <tr><td>southeastoutside*    </td><td>   [5 7]   </td><td>   [10 0]
% % </td></tr>
% % <tr><td>southwestoutside*    </td><td>   [7 5]   </td><td>   [-10 0]
% % </td></tr>
% % </table>
% % </html>
% %
% % One major difference between legend and legendflex is that legendflex
% % never resizes an axis in order to make room for a legend, as can be seen
% % in the examples below.
% 
% x = -pi:0.01:pi;
% y = [cos(x); sin(x)];
% lbl = {'cos', 'sin'};
% 
% ttlprop = {'fontsize',8};
% 
% figure;
% subplot(2,2,1);
% plot(x,y);
% legend(lbl);
% title('legend', ttlprop{:});
% ylabel('northeast (default)');
% subplot(2,2,2);
% plot(x,y);
% legendflex(lbl);
% title('legendflex', ttlprop{:});
% subplot(2,2,3);
% plot(x,y);
% legend(lbl, 'location', 'northoutside');
% ylabel('northoutside');
% % title('legend(lbl, ''location'', ''westoutside'')', ttlprop{:});
% subplot(2,2,4);
% plot(x,y);
% legendflex(lbl, 'anchor', {'n','s'}, 'buffer', [0 10]);
% % title('legendflex(lbl, ''anchor'', {''w'',''e''}, ''buffer'', [-10 0])', ttlprop{:});
% 
% %%
% % While the combination of anchors and buffers is a little more complicaed
% % to remember than a simple location string, it allows a lot more
% % flexibility in the positioning of a legend.  I originally wrote the
% % function to deal with figures holding lots of subplots.  Often, the
% % best location for a legend, to my eye, was not within any of the axes
% % themselves, but rather in the unused figure space.  In the following
% % example, I place a legend in an empty subplot grid, positioning it
% % relative to the axis above that empty slot.
% 
% data = cell(5);
% for ii = 1:24
%     data{ii} = rand(10,3);
% end
% 
% % This plotting function plots the data in the cell array onto a grid of
% % axes.  The output h.ax is a 5x5 array of the axis handles created.  The
% % inputs tell the function to plot the contents with no row or column
% % labels, spacing between axes to be 0.01 normalized to the figure, and to
% % not create axes for empty cells.
% 
% h = plotgrid(@(y) plot(1:10,y), data, [],[],'sp', 0.02,'sparse');
% set(h.ax(1:24), 'xtick',[],'ytick',[]);
% 
% % Add the legend where a final subplot could fit
% 
% legendflex(h.ax(1,1), {'one','two','three'}, ...
%            'ref', h.ax(4,5), ...
%            'anchor', {'s','n'}, ...
%            'buffer', [0 -0.02], ...
%            'bufferunit', 'normalized');
%        
% %%
% % Note that in that example, the legend "belongs" to axis (1,1), i.e. the
% % axis in the upper right corner, but is positioned relative to axis (4,5).
% % The object used to position a legend doesn't have to have any relation to
% % the axis (or handles) being labeled; it can be a different axis, the
% % figure, a uicontrol, an axis in a completely different figure, etc.
% % 
% % In the quest to squeeze legends into figures wherever they can fit, I
% % also added the ability to arrange the legend entries into grids:
% 
% h = plotgrid(@(y) plot(1:10,y), data, [],[],'sp', 0.02,'sparse');
% legendflex(h.ax(1,1), {'one','two','three'}, ...
%            'ref', h.fig, ...
%            'anchor', {'s','s'}, ...
%            'buffer', [0 0], ...
%            'box','off',...
%            'nrow', 1);
%        
% %%
% % You can also reduce the width of a legend by changing the xscale of the
% % legend symbols:
% 
% h = plotgrid(@(y) plot(1:10,y), data, [],[],'sp', 0.02,'sparse');
% legendflex(h.ax(1,1), {'one','two','three'}, ...
%            'ref', h.fig, ...
%            'anchor', {'e','e'}, ...
%            'buffer', [-5 0], ...
%            'xscale', 0.3, ...
%            'fontsize', 8);
       
%%  Example figure demonstrating as much as possible
       
figure('color','w');
% setpos(gcf, '# # 800px 600px');
for iax = 1:3
    ax(iax) = subplot(2,2,iax);
end

linespec = [repmat({'r';'b';'g';'c';'m'},2,1), ...
            [repmat({'-'}, 5, 1); repmat({'--'}, 5, 1)]];


x = [0 10];
y = (1:10)'*x;
lbl = cellstr(num2str((1:10)'));

hln(:,1) = plot(ax(1), x, y);
set(hln(:,1), {'color','linestyle'}, linespec);
[hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
    legendflex(hln(:,1), lbl, 'anchor', {'nw','nw'}, 'buffer', [5 -5], 'ncol', 3, 'fontsize', 8, 'xscale', 0.8, 'box', 'off');


hln(:,2) = plot(ax(2), x, y);
set(hln(:,2), {'color','linestyle'}, linespec);
[hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
    legendflex(hln(1:5,2), lbl(1:5), 'anchor', {'nw','nw'}, 'buffer', [5 -5], 'fontsize',8,'xscale',0.5, 'title', 'Color');
[hl(3).leg, hl(3).obj, hl(3).hout, hl(3).mout] = ...
    legendflex(hln([1 6],2), {'thing 1', 'thing 2'}, 'ref', hl(2).leg, 'anchor', {'ne','nw'}, 'buffer', [0 0], 'fontsize', 8', 'title', 'Line');

[X,Y] = meshgrid(-2:.2:2);
Z = X.*exp(-X.^2 - Y.^2);
[DX,DY] = gradient(Z,.2,.2);
axes(ax(3));
hold on;
[c,hcont] = contourf(X,Y,Z);
hquiv = quiver(X,Y,DX,DY);

[hl(4).leg, hl(4).obj, hl(4).hout, hl(4).mout] = ...
    legendflex([hcont hquiv], {'contour', 'quiver'}, 'anchor',{'ne','se'}, 'buffer',[0, 0.01], 'bufferunit', 'normalized');

multitextloc(ax, {'(a)','(b)','(c)'}, 'northwestoutsideabove');
txt = {...
    'legendflex.m: a more flexible legend'
    ''
    '- Positioning scheme allows legend to be aligned with almost any object in a figure, not just the parent axis'
    ''
    '- Legend entries can be arranged in multi-row, multi-column grids'
    ''
    '- Multiple legends can be added to a single axis'
    ''
    '- Titles can be added within the legend box'
    ''
    '- Legend symbol width can be rescaled'
    ''
    '- Supports all types of plot objects'
};
axtmp = subplot(2,2,4);
pos = getpos(axtmp, 'px');
delete(axtmp);
hui = uicontrol('style','text', 'position', pos, 'backgroundcolor', 'w', 'horiz', 'left');
txt = textwrap(hui, txt);
set(hui, 'string', txt);

% export_fig('legendflex', gcf, '-png', '-pdf', '-r300');

%% Testing new legend

% Demonstrating one output vs two output bug

% A plot with lots o' things, legend with 1 output

ax = gobjects(3,2);

ax(1) = subplot(3,2,1);
hold on;
[x,y,z] = peaks;
[c,hc] = contourf(x,y,z);
hl = plot(-3:3, -3:3);
hb = bar(1:3, rand(3,1));
hs = scatter(rand(10,1), rand(10,1), 10:19, 1:10, 'filled');

hobj = [hc hl hb hs];
lbl = {'contour', 'line', 'bar', 'scatter'};

[hleg,ho] = deal(cell(6,1));
hleg{1} = legend(hobj, lbl{:});
title('1 output');

% Same plot, legend with 2 outputs, invarying orders

for ii = 1:4
    
    ax(ii+1) = subplot(3,2,ii+1);
    hnew = copyobj(hobj, ax(ii+1));
    
    order = circshift(1:4,ii-1,2);
    [hleg{ii+1},ho{ii+1}] = legend(hnew(order), lbl{order});
    
    title(sprintf('2 outputs, contour #%d',ii));

end

%% Testing new padding

x = [0 10];
y = (1:10)'*x;
lbl = cellstr(num2str((1:10)'));
hln(:,1) = plot(x, y);
set(hln(:,1), {'color','linestyle'}, linespec);
legendflex(hln(:,1), lbl, 'anchor', {'nw','nw'}, 'buffer', [5 -5], 'ncol', 3, 'fontsize', 8, 'xscale', 0.8, 'box', 'on', 'padding', [0 0 0]);

%%

