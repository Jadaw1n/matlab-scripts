function [] = calculateIt(val1, val2)

% Testinputs:
% ----------------
% Zwei Ebenen:
% Ebenen sind gleich:
% calculateIt(param2coord([0 4 1], [1 -3 -1], [4 -3 1]), param2coord([1 1 0],[-1 3 1],[3 0 2]))
% Schnittgerade:
% calculateIt(coord([1 1 1 1]), coord([1 -1 2 -3]))
% Ebenen parallel:
% calculateIt(coord([6 -3 1.5 -4.2]), coord([-4 2 -1 -2]))

% Zwei Geraden:
% Schnittpunkt:
% calculateIt(line2vec([4 2 8], [-1 4 3]),line2vec([5 8 21],[1 1 5]))
% Windschief:
% calculateIt(line2vec([1 0 1], [2 2 1]),line2vec([4 3 1],[1 -2 2]))
% parallel:
% calculateIt(line2vec([2 0 1], [1 2 1]),line2vec([4 4 4], [-1 -2 -1]))
% identisch:
% calculateIt(line2vec([2 0 2], [1 2 1]),line2vec([4 4 4], [-1 -2 -1]))

% Ebene / Gerade:
% Parallel:
% calculateIt(coord([4, 4, 4, -5]), line2vec([100 100 100], [1 0 -1]))
% Schnittpunkt:
% calculateIt(coord([1 3 -2 10]), line2vec([0 1 0], [0 -1 2]))
% Liegt in der Ebene:
% calculateIt(coord([1 3 -2 0]), line2vec([0 0 0], [0 -2 2]))



% don't display warnings
warning('off','all');



if strcmp(val1.type, 'line')
    if strcmp(val2.type, 'line')
        calcLL(val1.value, val2.value)
    else
        calcPL(val2.value, val1.value)
    end
else
    if strcmp(val2.type, 'line')
        calcPL(val1.value, val2.value)
    else
        calcPP(val1.value, val2.value)
    end
end

disp ' ' % print empty line for better visuals
end

function [] = calcLL(l1, l2)
disp 'Lage zweier Geraden zueinander'
disp '------------------------------'
disp ' '

[r01, a1] = getLineParts(l1);
[~, a2] = getLineParts(l2);

% Richtungsvektoren auf lineare Abhängigkeit überprüfen.
quotient = rdivide(a1, a2);

if min(quotient) == max(quotient) % Richtungsvektoren sind lin.Ab. wenn alle Quotienten gleich sind.
    if isempty(solve(r01==l2))
        disp 'Geraden sind parallel.'
    else
        disp 'Geraden sind identisch.'
    end
else
    syms t s;

    l2 = subs(l2, t, s); % Zweite Variable beim Gleichsetzen nötig
    [t0, s0] = solve(l1==l2, t, s);
    if(isempty(s0))
        disp 'Geraden sind windschief.'
    else
        l1 = [l1(1); l1(2); l1(3)]; % Schönere Anzeigeart sicherstellen
        disp 'Schnittpunkt:'
        disp(subs(l1, t, t0))
    end

end

end

function [] = calcPL(p1, l1)
disp 'Lage einer Ebene und einer Gerade zueinander'
disp '--------------------------------------------'
disp ' '

syms x y z t;

% Gerade in Ebene einsetzen
% x y z mit l1 ersetzen. Dann alle ArrayElemente aufsummieren (Ebenengleichung).
gline = sum(subs(p1, [x y z], l1));

if(gline ~= 0)
    if(length(symvar(gline)) == 1)
        t0 = solve(gline);
        disp 'Schnittpunkt:'
        disp(subs(l1, t, t0))
    else
        disp 'Gerade ist parallel zur Ebene.'
    end
else
    disp 'Gerade liegt in der Ebene.'
    prettyLine(l1)
end

end

function [] = calcPP(p1, p2)
disp 'Lage zweier Ebenen zueinander'
disp '-----------------------------'
disp ' '

% Elementweise dividieren. Wenn im Ergebnis alle Zahlen den gleichen
% Quotient haben (lineare Abhängigkeit), dann sind die Ebenen gleich. Wenn 
% nur die ersten 3 Elemente (Normalenvektor) den gleichen Quotient haben, 
% dann sind die Ebenen parallel.
quotient = rdivide(p1, p2);

if(min(quotient) == max(quotient)) % Alle Elemente gleich
    disp 'Ebenen sind gleich'
elseif(min(quotient(1:3)) == max(quotient(1:3))) % Normalenvektor gleich
    disp 'Ebenen sind parallel.'
else
    % Schnittgerade berechnen
    
    syms x y z t;

    LGS = rref([p1 0; p2 0]); % LGS in ZSF bringen
    
    if LGS(1,1) == 0  % wenn x == 0
        % Elementweise mit t y z 1 1 multiplizieren und die Zeile addieren.
        LGS1 = sum(times(LGS(1,1:5), [t y z 1 1]));
        LGS2 = sum(times(LGS(2,1:5), [t y z 1 1]));
        
        sg = [t ; solve(LGS1, y) ; solve(LGS2, z)]; % nach y und z auflösen

    elseif LGS(2,2) == 0 % wenn y == 0
        % Elementweise mit x t z 1 1 multiplizieren und die Zeile addieren.
        LGS1 = sum(times(LGS(1,1:5), [x t z 1 1]));
        LGS2 = sum(times(LGS(2,1:5), [x t z 1 1]));
        
        sg = [solve(LGS1, x) ; t ; solve(LGS2, z)]; % nach x und z auflösen

    else
        % Elementweise mit x y t 1 1 multiplizieren und die Zeile addieren.
        LGS1 = sum(times(LGS(1,1:5), [x y t 1 1]));
        LGS2 = sum(times(LGS(2,1:5), [x y t 1 1]));
            
        sg = [solve(LGS1, x) ; solve(LGS2, y) ; t]; % nach x und y auflösen
    end
    
    disp 'Schnittgerade:'
    prettyLine(sg)
    
end

end

function [r0, a] = getLineParts(l)
syms t

a = diff(l, t);
r0 = subs(l, t, 0);
end

function [] = prettyLine(sg)
% function to print a line nicely

[r0, a] = getLineParts(sg);

a = arrayfun(@(x) char(x), a, 'UniformOutput', false);
r0 = arrayfun(@(x) char(x), r0, 'UniformOutput', false);
alen = int2str(max(cellfun(@(x) numel(x),a)));
r0len = int2str(max(cellfun(@(x) numel(x),r0)));

fprintf(strcat('  %', r0len, 's           %', alen, 's  \n'), r0{1}, a{1});
fprintf(strcat('( %', r0len, 's ) + t * ( %', alen, 's )\n'), r0{2}, a{2});
fprintf(strcat('  %', r0len, 's           %', alen, 's  \n'), r0{3}, a{3});

end