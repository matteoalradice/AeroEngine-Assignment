
validate = true;

[JT8D, Leap1B, general, Leap1A, validation] = initial_data;

if validate == true
    engine = Leap1A;
    general = validation;
    n_engines = 1;
else
    n_engines = 2;
end

for i = 1:n_engines
    if validate == false
        if i == 1
            engine = JT8D;
        else
            engine = Leap1B;
        end
    end

    res = calculator(engine,general);












end