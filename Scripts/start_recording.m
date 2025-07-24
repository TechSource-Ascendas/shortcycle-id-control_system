function start_recording(model_name)
    warning('off','all') % Trust me
    set_param(model_name,SimulationCommand="start");
    Simulink.sdi.view;
    pause(3);
    while strcmp(get_param(model_name, 'SimulationStatus'), 'external')
        pause(1);
    end
    warning('on','all')
end