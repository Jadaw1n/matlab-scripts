syms x;
f = sqrt(1+sqrt(1+x^2));

fA1 = taylor(f,x,'ExpansionPoint',0,'Order',2);
fA2 = taylor(f,x,'ExpansionPoint',0,'Order',3);
fA3 = taylor(f,x,'ExpansionPoint',0,'Order',4);
fA4 = taylor(f,x,'ExpansionPoint',0,'Order',5);

p = ezplot(f);
axis equal;
hold;

p = ezplot(fA1);
set(p,'Color','r')
p = ezplot(fA2);
set(p,'Color','g')
p = ezplot(fA3);
set(p,'Color','y')
p = ezplot(fA4);
set(p,'Color','b')