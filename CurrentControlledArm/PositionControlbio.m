function bio=PositionControlbio
bio = [];
bio(1).blkName='Saturation';
bio(1).sigName='';
bio(1).portIdx=0;
bio(1).dim=[1,1];
bio(1).sigWidth=1;
bio(1).sigAddress='&PositionControl_B.Saturation_n';
bio(1).ndims=2;
bio(1).size=[];

bio(getlenBIO) = bio(1);

bio(2).blkName='Analog input/p1';
bio(2).sigName='';
bio(2).portIdx=0;
bio(2).dim=[1,1];
bio(2).sigWidth=1;
bio(2).sigAddress='&PositionControl_B.Analoginput_o1';
bio(2).ndims=2;
bio(2).size=[];


bio(3).blkName='Analog input/p2';
bio(3).sigName='';
bio(3).portIdx=1;
bio(3).dim=[1,1];
bio(3).sigWidth=1;
bio(3).sigAddress='&PositionControl_B.Analoginput_o2';
bio(3).ndims=2;
bio(3).size=[];


bio(4).blkName='Sine Wave';
bio(4).sigName='';
bio(4).portIdx=0;
bio(4).dim=[1,1];
bio(4).sigWidth=1;
bio(4).sigAddress='&PositionControl_B.SineWave';
bio(4).ndims=2;
bio(4).size=[];


bio(5).blkName='Sum';
bio(5).sigName='';
bio(5).portIdx=0;
bio(5).dim=[1,1];
bio(5).sigWidth=1;
bio(5).sigAddress='&PositionControl_B.Sum';
bio(5).ndims=2;
bio(5).size=[];


bio(6).blkName='ArmEncoder/To Rad';
bio(6).sigName='';
bio(6).portIdx=0;
bio(6).dim=[1,1];
bio(6).sigWidth=1;
bio(6).sigAddress='&PositionControl_B.ToRad';
bio(6).ndims=2;
bio(6).size=[];


bio(7).blkName='ArmEncoder/EncoderPos';
bio(7).sigName='';
bio(7).portIdx=0;
bio(7).dim=[1,1];
bio(7).sigWidth=1;
bio(7).sigAddress='&PositionControl_B.EncoderPos';
bio(7).ndims=2;
bio(7).size=[];


bio(8).blkName='ArmEncoder/SSIM';
bio(8).sigName='';
bio(8).portIdx=0;
bio(8).dim=[1,1];
bio(8).sigWidth=1;
bio(8).sigAddress='&PositionControl_B.SSIM';
bio(8).ndims=2;
bio(8).size=[];


bio(9).blkName='Discrete PID Controller/Integrator';
bio(9).sigName='';
bio(9).portIdx=0;
bio(9).dim=[1,1];
bio(9).sigWidth=1;
bio(9).sigAddress='&PositionControl_B.Integrator';
bio(9).ndims=2;
bio(9).size=[];


bio(10).blkName='Discrete PID Controller/Integral Gain';
bio(10).sigName='';
bio(10).portIdx=0;
bio(10).dim=[1,1];
bio(10).sigWidth=1;
bio(10).sigAddress='&PositionControl_B.IntegralGain';
bio(10).ndims=2;
bio(10).size=[];


bio(11).blkName='Discrete PID Controller/Proportional Gain';
bio(11).sigName='';
bio(11).portIdx=0;
bio(11).dim=[1,1];
bio(11).sigWidth=1;
bio(11).sigAddress='&PositionControl_B.ProportionalGain';
bio(11).ndims=2;
bio(11).size=[];


bio(12).blkName='Discrete PID Controller/Saturation';
bio(12).sigName='';
bio(12).portIdx=0;
bio(12).dim=[1,1];
bio(12).sigWidth=1;
bio(12).sigAddress='&PositionControl_B.Saturation';
bio(12).ndims=2;
bio(12).size=[];


bio(13).blkName='Discrete PID Controller/Sum';
bio(13).sigName='';
bio(13).portIdx=0;
bio(13).dim=[1,1];
bio(13).sigWidth=1;
bio(13).sigAddress='&PositionControl_B.Sum_k';
bio(13).ndims=2;
bio(13).size=[];


bio(14).blkName='Discrete PID Controller/Switch';
bio(14).sigName='';
bio(14).portIdx=0;
bio(14).dim=[1,1];
bio(14).sigWidth=1;
bio(14).sigAddress='&PositionControl_B.Switch';
bio(14).ndims=2;
bio(14).size=[];


bio(15).blkName='Discrete PID Controller/Clamping circuit/DataTypeConv2';
bio(15).sigName='';
bio(15).portIdx=0;
bio(15).dim=[1,1];
bio(15).sigWidth=1;
bio(15).sigAddress='&PositionControl_B.DataTypeConv2';
bio(15).ndims=2;
bio(15).size=[];


bio(16).blkName='Discrete PID Controller/Clamping circuit/DeadZone';
bio(16).sigName='';
bio(16).portIdx=0;
bio(16).dim=[1,1];
bio(16).sigWidth=1;
bio(16).sigAddress='&PositionControl_B.DeadZone';
bio(16).ndims=2;
bio(16).size=[];


bio(17).blkName='Discrete PID Controller/Clamping circuit/Gain';
bio(17).sigName='';
bio(17).portIdx=0;
bio(17).dim=[1,1];
bio(17).sigWidth=1;
bio(17).sigAddress='&PositionControl_B.Gain';
bio(17).ndims=2;
bio(17).size=[];


bio(18).blkName='Discrete PID Controller/Clamping circuit/AND';
bio(18).sigName='';
bio(18).portIdx=0;
bio(18).dim=[1,1];
bio(18).sigWidth=1;
bio(18).sigAddress='&PositionControl_B.AND';
bio(18).ndims=2;
bio(18).size=[];


bio(19).blkName='Discrete PID Controller/Clamping circuit/Equal';
bio(19).sigName='';
bio(19).portIdx=0;
bio(19).dim=[1,1];
bio(19).sigWidth=1;
bio(19).sigAddress='&PositionControl_B.Equal';
bio(19).ndims=2;
bio(19).size=[];


bio(20).blkName='Discrete PID Controller/Clamping circuit/NotEqual';
bio(20).sigName='';
bio(20).portIdx=0;
bio(20).dim=[1,1];
bio(20).sigWidth=1;
bio(20).sigAddress='&PositionControl_B.NotEqual';
bio(20).ndims=2;
bio(20).size=[];


bio(21).blkName='Discrete PID Controller/Clamping circuit/SignPreIntegrator';
bio(21).sigName='';
bio(21).portIdx=0;
bio(21).dim=[1,1];
bio(21).sigWidth=1;
bio(21).sigAddress='&PositionControl_B.SignPreIntegrator';
bio(21).ndims=2;
bio(21).size=[];


bio(22).blkName='Discrete PID Controller/Clamping circuit/SignPreSat';
bio(22).sigName='';
bio(22).portIdx=0;
bio(22).dim=[1,1];
bio(22).sigWidth=1;
bio(22).sigAddress='&PositionControl_B.SignPreSat';
bio(22).ndims=2;
bio(22).size=[];


function len = getlenBIO
len = 22;

