clc; clear; close;

an_x1 = (-4 - sqrt(4 * 4 - 4 * 29 * (-1999)))/ (2 * 29);
an_x2 = (-4 + sqrt(4 * 4 - 4 * 29 * (-1999)))/ (2 * 29);
printf('\n Analytical:\t x1 = %.8f, x2 = %.8f', an_x1, an_x2);

p = [29 4 -1999]
p_roots = roots(p)
printf('\n SciLab:\t x1 = %.8f, x2 = %.8f', p_roots(1), p_roots(2));

deff('x=f(x)','x=29*x^2+4*x-1999');
deff('x=f1(x)','x=58*x+4');

x0 = -0.0689655;
steps = 10;

printf('\n\n n\txn\t\t\f(xn)\t\tf1(xn)\t\tXn+1\t\tError\n');

for i = 1:steps
    x1 = x0 - f(x0) / f1(x0);
    err = abs(x0 - x1);
    printf(' %i\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\n', i - 1, x0, f(x0), f1(x0), x1, err);
    x0 = x1;
end
printf('\nNumerical: x1 = %.8f', x0);
