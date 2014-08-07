function str = caster_input_display_helper()
% This function allows for the monitor block to list which signals it
% accepts.

str = 'Signal Key:\n';
caster = caster_fsm_setup();

keys = caster.inputMap.keys;
values = caster.inputMap.values;

for k = 1:length(keys)
    str = strcat(str,sprintf('%d : %s',keys{k}, values{k}),'\n');
end

