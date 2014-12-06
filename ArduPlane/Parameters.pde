/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

/*
 *  ArduPlane parameter definitions
 *
 */

#define GSCALAR(v, name, def) { g.v.vtype, name, Parameters::k_param_ ## v, &g.v, {def_value : def} } 
#define ASCALAR(v, name, def) { aparm.v.vtype, name, Parameters::k_param_ ## v, &aparm.v, {def_value : def} }
#define GGROUP(v, name, class) { AP_PARAM_GROUP, name, Parameters::k_param_ ## v, &g.v, {group_info : class::var_info} }
#define GOBJECT(v, name, class) { AP_PARAM_GROUP, name, Parameters::k_param_ ## v, &v, {group_info : class::var_info} }
#define GOBJECTN(v, pname, name, class) { AP_PARAM_GROUP, name, Parameters::k_param_ ## pname, &v, {group_info : class::var_info} }

const AP_Param::Info var_info[] PROGMEM = {
    // @Param: FORMAT_VERSION
    // @DisplayName: �洢����ʽ������
    // @Description: ÿ�θ��´洢��������Ӹ���ֵ��
    // @User: Advanced
    GSCALAR(format_version,         "FORMAT_VERSION", 0),

    // @Param: SYSID_SW_TYPE
    // @DisplayName: �������
    // @Description: ����վ����ʶ����������� (���磺�̶��� �� ����)
    // @User: Advanced
    GSCALAR(software_type,          "SYSID_SW_TYPE",  Parameters::k_software_type),

    // @Param: SYSID_THISMAV
    // @DisplayName: MAVLinkϵͳID
    // @Description: MAVLinkЭ���У���ǰ�豸��ʶ���š�
    // @Range: 1 255
    // @User: Advanced
    GSCALAR(sysid_this_mav,         "SYSID_THISMAV",  MAV_SYSTEM_ID),

    // @Param: SYSID_MYGCS
    // @DisplayName: ����վMAVLinkϵͳID
    // @Description: MAVLinkЭ���У�����վ��ʶ���š�����ͬʱ�Ե���վ�����޸ģ�����Ҫ���ġ�
    // @Range: 1 255
    // @User: Advanced
    GSCALAR(sysid_my_gcs,           "SYSID_MYGCS",    255),

    // @Param: SERIAL0_BAUD
    // @DisplayName: USB�˿ڲ�����
    // @Description: ����USB�ӿڵĲ��������á�APM2����֧����ߵ�115, Ҳ����֧��500��PX4��֧�ֵ�1500���������APM2��������һ������֧�ֵĲ����ʣ������޷����ӷɿأ�����ͨ�����¼��ع̼��ķ�ʽ�ָ�Ĭ�ϲ��������ӣ��⽫�����������õĲ����ָ�Ĭ�ϡ�
    // @Values: 1:1200,2:2400,4:4800,9:9600,19:19200,38:38400,57:57600,111:111100,115:115200,500:500000,921:921600,1500:1500000
    // @User: Standard
    GSCALAR(serial0_baud,           "SERIAL0_BAUD",   SERIAL0_BAUD/1000),

    // @Param: SERIAL1_BAUD
    // @DisplayName: ��һ�����ӿڲ�����
    // @Description: ͨ��������������ڵ�һ�����˿ڡ�APM2����֧����ߵ�115, Ҳ����֧��500��PX4��֧�ֵ�1500���������APM2��������һ������֧�ֵĲ����ʣ������޷����ӷɿأ�����ͨ�����¼��ع̼��ķ�ʽ�ָ�Ĭ�ϲ��������ӣ��⽫�����������õĲ����ָ�Ĭ�ϡ�
    // @Values: 1:1200,2:2400,4:4800,9:9600,19:19200,38:38400,57:57600,111:111100,115:115200,500:500000,921:921600,1500:1500000
    // @User: Standard
    GSCALAR(serial1_baud,           "SERIAL1_BAUD",   SERIAL1_BAUD/1000),

#if MAVLINK_COMM_NUM_BUFFERS > 2
    // @Param: SERIAL2_BAUD
    // @DisplayName: �ڶ������ӿڲ�����
    // @Description: ������������ڵڶ������˿ڡ�APM2����֧����ߵ�115, Ҳ����֧��500��PX4��֧�ֵ�1500���������APM2��������һ������֧�ֵĲ����ʣ������޷����ӷɿأ�����ͨ�����¼��ع̼��ķ�ʽ�ָ�Ĭ�ϲ��������ӣ��⽫�����������õĲ����ָ�Ĭ�ϡ�
    // @Values: 1:1200,2:2400,4:4800,9:9600,19:19200,38:38400,57:57600,111:111100,115:115200,500:500000,921:921600,1500:1500000
    // @User: Standard
    GSCALAR(serial2_baud,           "SERIAL2_BAUD",   SERIAL2_BAUD/1000),

#if FRSKY_TELEM_ENABLED == ENABLED
    // @Param: SERIAL2_PROTOCOL
    // @DisplayName: �ڶ������ӿ�Э��ѡ��
    // @Description: �ò������Ƶڶ������ӿ�ʹ������Э�顣
    // @Values: 1:����վMavlink,2:�˼��D-PORT
    // @User: Standard
    GSCALAR(serial2_protocol,        "SERIAL2_PROTOCOL", SERIAL2_MAVLINK),
#endif // FRSKY_TELEM_ENABLED

#endif // MAVLINK_COMM_NUM_BUFFERS

    // @Param: AUTOTUNE_LEVEL
    // @DisplayName: �Զ����μ���
    // @Description: �Զ�����ʱ�Ķ������ҳ̶ȡ� ���Զ����������ڽϵͼ���ʱ�����εĳ̶Ȼ�Ƚϡ������õ���ƽ�͵����档�Ƽ������ʹ��������Ϊ6��
    // @Range: 1 10
    // @Increment: 1
    // @User: Standard
    ASCALAR(autotune_level, "AUTOTUNE_LEVEL",  6),

    // @Param: TELEM_DELAY
    // @DisplayName: ����������ʱ 
    // @Description: �ӳ��������ӵ�ʱ�䣨�룩�����ڽ��Xbee�ϵ�����ʱ��Ӧ��
    // @User: Standard
    // @Units: ��
    // @Range: 0 10
    // @Increment: 1
    GSCALAR(telem_delay,            "TELEM_DELAY",     0),

    // @Param: KFF_RDDRMIX
    // @DisplayName: �������
    // @Description: �������ϸ�����ʱ�Ļ�ر�����0 = 0 %, 1 = 100%
    // @Range: 0 1
    // @Increment: 0.01
    // @User: Standard
    GSCALAR(kff_rudder_mix,         "KFF_RDDRMIX",    RUDDER_MIX),

    // @Param: KFF_THR2PTCH
    // @DisplayName: ���ŵ������Ļ��
    // @Description: ���������ڸ�����ǰ�����档
    // @Range: 0 5
    // @Increment: 0.01
    // @User: Advanced
    GSCALAR(kff_throttle_to_pitch,  "KFF_THR2PTCH",   0),

    // @Param: STAB_PITCH_DOWN
    // @DisplayName: �������½�΢�� 
    // @Description: ������������ˣ����ڵ����Ÿ�����ʱ��FBWA��AUTOTUNEģʽ����ʱ���½��������Ÿ�λ�ó���TRIM_THROTTLE�������趨ֵʱ���ɻ���������½�����������TRIM_THROTTLE�������趨ֵʱ���ͻᰴ�վ�������Ÿ�λ�ã������½�������0���Ÿ�λ��ʱ���ͻ�ʹ�õ�ǰ�����趨���������½������������Ŀ�ľ���Ϊ����FBWAģʽС����������ʱ�������ɻ����ֿ��٣���������½����ʱ���Բ����������ټơ�2�ȵ�Ĭ��ֵ���ʺϴ󲿷ַɻ������ߵ���ֵ�����ʺϽϴ���������ķɻ���
    // @Range: 0 15
    // @Increment: 0.1
    // @Units: ��
    // @User: Advanced
    GSCALAR(stab_pitch_down, "STAB_PITCH_DOWN",   2.0f),

    // @Param: GLIDE_SLOPE_MIN
    // @DisplayName: �����½��߶�
    // @Description: ������С�ĺ���߶ȸı䣬���Խ��л��裬������ֱ���½��߶ȡ�Ĭ��ֵΪ15�ף��⽫�����ɻ��������Ͻ��ĺ���䣬ƽ���Ľ��и߶ȵ�������������ڴ�ʹ�û��蹦�ܣ�����0Ϊ���á�
    // @Range: 0 1000
    // @Increment: 1
    // @Units: ��
    // @User: Advanced
    GSCALAR(glide_slope_threshold, "GLIDE_SLOPE_MIN", 15),

    // @Param: STICK_MIXING
    // @DisplayName: ҡ�˻��
    // @Description: �������ʹ�ã������Զ�����ģʽʱ������RC���Ʒɻ��������л�����ģʽ������������ģʽ�������ã�����Ϊ1ʱ��������FBW��ģʽ�����Ʒɻ������FBW-A�Ĳ���͸�������һ��������㳣��FBW-A��FBW-Bģʽ�����У����Ǹ���ȫ��ѡ������Ϊ2ʱ����ʹ������ģʽSTABILIZE�����У�����������AUTOģʽ���и����ҵĲ�����
    // @Values: 0:Disabled,1:FBWMixing,2:DirectMixing
    // @User: Advanced
    GSCALAR(stick_mixing,           "STICK_MIXING",   STICK_MIXING_FBW),

    // @Param: SKIP_GYRO_CAL
    // @DisplayName: ��ֹ�����������Լ�
    // @Description: ���������ѡ��ʱ��APM��������ʱ����������У׼����ʹ���ϴη���ʱ��������������ݣ����һ��Ҫ�ڷ���ǰȷ�ϸ߶ȵ����ݣ���ΪһЩ���ӿ���������ʱ��������У׼���������ԵĲ�ͬ, �������¶ȵı仯������Ӱ�졣�����������У׼��������APM���������ļ����Ӻ����������ǵ��ƶ�̽�⹦��ȥ�ռ���ȷ��У׼���ݡ���������ڽ��ĳЩ����ʱ�ǳ����á�
    // @Values: 0:����,1:����
    // @User: Advanced
    GSCALAR(skip_gyro_cal,           "SKIP_GYRO_CAL",   0),

    // @Param: AUTO_FBW_STEER
    // @DisplayName: ��AUTO����ģʽ��ʹ��FBW-A�Ŀ��ƹ���
    // @Description: �������ѡ��󣬻���Auto����ģʽ�����ʹ����FBW-A��ͬ���ֶ��ٿع��ܣ���Autoģʽ�ĵ������ܽ�����ȫ���ã��������ʱ������ʹ�ô˹��ܡ�
    // @Values: 0:����,1:����
    // @User: Advanced
    GSCALAR(auto_fbw_steer,          "AUTO_FBW_STEER",   0),

    // @Param: TKOFF_THR_MINSPD
    // @DisplayName: ���ʱ�Զ��������ŵ���С�ٶ�
    // @Description: �ò������ڿ����Զ����ʱ������������������ݵ���СGPS�����ٶȼ�⡣����������ڵ������ʱ��ϣ���ɻ��������ȥ�������������ٵ���������ڵ�����ɣ������� TKOFF_THR_MINACC �� TKOFF_THR_DELAY ����ʹ�ý��У��Թ��GPS�������µ����⡣ǿ�ҽ����������ɻ�Ͷ�����ʱ�����õ���ֵ������4��/�룬����Ա���������������ע�⣺GPS���ʻ��ͺ���ʵ��0.5�롣ͬʱ���ټ��Ҳ�ᱻ TKOFF_THR_DELAY �������ӳ١�
    // @Units: ��/��
    // @Range: 0 30
    // @Increment: 0.1
    // @User: User
    GSCALAR(takeoff_throttle_min_speed,     "TKOFF_THR_MINSPD",  0),

    // @Param: TKOFF_THR_MINACC
    // @DisplayName: ���ʱ�Զ��������ŵ���С���ٶ�
    // @Description: �Զ����ģʽ�£�����������Ҫ����С����ǰ������ٶȣ���/��/�룩������ζ��ҪͶ����ɡ�����Ϊ0�����ü��ٶȼ�⣬���Ž����ڽ���״̬��������GPS�������������Ͷ���͵������Ӧ��������15��/�븽����
    // @Units: ��/��/��
    // @Range: 0 30
    // @Increment: 0.1
    // @User: User
    GSCALAR(takeoff_throttle_min_accel,     "TKOFF_THR_MINACC",  0),

    // @Param: TKOFF_THR_DELAY
    // @DisplayName: ��������ӳٿ���
    // @Description: ��TKOFF_THR_MINACC�������õ���С���ٶȴﵽ�����ӳٶ೤ʱ�䣨1/10�룩���������������ʽ�������ɻ���Ͷ�����ʱ�����ֵ���ܵ���2��0.2�룩��ȷ���������뿪Ͷ���ߵ��ֱ۷�Χ�����������������ʱ���������ýϴ����ֵ������30���������㹻��ʱ�䣬�ȷɻ��뿪����ܺ������������
    // @Units: 0.1 ��
    // @Range: 0 127
    // @Increment: 1
    // @User: User
    GSCALAR(takeoff_throttle_delay,     "TKOFF_THR_DELAY",  2),

    // @Param: TKOFF_TDRAG_ELEV
    // @DisplayName: ��������͵����ʱ����������
    // @Description: ������������������������ɽ׶Σ����������Ӧ�ñ�������������������ڵ��滬��ʱ������ס������ɻ���β�֣�ת���֣�,���ַɻ������ʱ�ķ����ȶ����������Ӧ�ý�� TKOFF_TDRAG_SPD1 �� GROUND_STEER_ALT ����һ����е���ת����Ƶĵ�����0ֵΪ���������ʱ��β�ֱ��֣�������Ͷ���͵������ģʽ�¡����ں�����ɻ���ͨ������Ϊ100���⽫�����ʱʹ�����洦����������״̬��0ֵ�����ڴ����ǰ��������ܣ�������һЩǰ����ɻ���Ҫ�����ʱ�����������£��������ַɻ�����ɼ���ʱ��ǰ���ܱ��ֶԷ���Ŀ��ƣ�����Ϊ-20��-30�������Ƿ���������ǰ��ǰ�ֲ��ܺܺõĽӴ����棬����Ҫ����Ϊ��ֵ��ǰ����ɻ�ʹ�ô���ȵ�����������ʱ�������ת���飬���Ե���ʱ��ÿ����ཱུ��10%�����ԡ�
    // @Units: �ٷֱ�
    // @Range: -100 100
    // @Increment: 1
    // @User: User
    GSCALAR(takeoff_tdrag_elevator,     "TKOFF_TDRAG_ELEV",  0),

    // @Param: TKOFF_TDRAG_SPD1
    // @DisplayName: ���������������ǰ�ĵ����ٶ�1
    // @Description: �������������������ǰ���ﵽʲô�ٶȺ�ֹͣ����β�����£���ת�÷������Ƶ���ת�򡣵��������ֵ�ﵽ�󣬷ɻ�������ˮƽ��ֱ���ٶȴﵽTKOFF_ROTATE_SPD���������ã��ŻῪʼת�����������򺽵㡣����Ϊ0ʱ��ֱ�ӽ���ת���ʺ�Ͷ���͵�����ɣ�ǰ����ɻ�ҲӦ��Ϊ0��������ɻ�������Ӧ�Ե���ʧ���ٶȡ�
    // @Units: ��/��
    // @Range: 0 30
    // @Increment: 0.1
    // @User: User
    GSCALAR(takeoff_tdrag_speed1,     "TKOFF_TDRAG_SPD1",  0),

    // @Param: TKOFF_ROTATE_SPD
    // @DisplayName: ��ɺ�ʼת������ﵽ�ٶ�
    // @Description: ��ɺ�ﵽʲô�ٶȿ�ʼת����������趨�������дﵽ�趨���ٺ󣬷ɻ���ʼת�򲢽���ָ��������������������Ϊ0����ɺ�������������������׺͵������Ӧ����Ϊ0�����е������Ӧ����Ϊ����ʧ�ٵ��ٶȣ�ͨ��Ϊ10-30%��
    // @Units: ��/��
    // @Range: 0 30
    // @Increment: 0.1
    // @User: User
    GSCALAR(takeoff_rotate_speed,     "TKOFF_ROTATE_SPD",  0),

    // @Param: TKOFF_THR_SLEW
    // @DisplayName: �����������
    // @Description: ��������������Զ����ʱ�����ŵ��������ʡ�����Ϊ0ʱ����ɽ�ʹ�� THR_SLEWRATE ��������ֵ���ڲ�����ת���ʱ���������Ϊ�ϵ͵������������ʣ������ļ��ٽ���ǿ����ת��Ŀ������������ֵ�ǰٷֱ�/�룬���ԣ�20��ζ��5���Ż�ﵽ��������������Ƽ�ʹ�õ���20��ֵ�����ᵼ�·ɻ���С��������ʱ��Ϳ�ʼ������
    // @Units: �ٷֱ�
    // @Range: 0 127
    // @Increment: 1
    // @User: User
    GSCALAR(takeoff_throttle_slewrate, "TKOFF_THR_SLEW",  0),

    // @Param: TKOFF_FLAP_PCNT
    // @DisplayName: ��ɽ���ٷֱ�
    // @Description: �Զ����ʱ������򿪵Ŀ��ȣ��ٷֱȣ���
    // @Range: 0 100
    // @Units: �ٷֱ�
    // @User: Advanced
    GSCALAR(takeoff_flap_percent,     "TKOFF_FLAP_PCNT", 0),

    // @Param: FBWA_TDRAG_CHAN
    // @DisplayName: FBWAģʽ�µĺ��������ģʽ
    // @Description: ѡ��һ��RCͨ���������ã���ͨ��PWMֵ����1700���ϵ�ʱ����FBW-Aģʽ�У����ú���������ܵ����ģʽ����ͨ��Ӧ�ñ����õ�RCң�ص�ĳ�����ο����ϡ����ʹ��ʱ��һ��������ܱ��򿪣�������������ģʽ��ֱ���ɻ����ٳ���TKOFF_TDRAG_SPD1 �������趨ֵ��������;�ı����ģʽ��������̬�б仯��ͬʱ���������һ���򿪣������潫ǿ�ƽ���TKOFF_TDRAG_ELEV���趨ֵ����Щ���ܶ���Ϊ�����ú�����ʽ�ɻ���FBW-Aģʽ�и����׵���ɣ�ͬʱ���㴦���Զ���ɺ�ת��0Ϊ���á�
    // @User: Standard
    GSCALAR(fbwa_tdrag_chan,          "FBWA_TDRAG_CHAN",  0),

    // @Param: LEVEL_ROLL_LIMIT
    // @DisplayName: ˮƽ����ʱ���������
    // @Description: ƽ��ʱ���������в�����������Ƕȣ�����5�ȣ��������������½ʱ�����������Ƕȣ����ܻ�ʹ����������ܵ�������Ϊ0ʱ�����Զ���ɺ���½ʱ����ȫ���÷��򱣳֡�
    // @Units: ��
    // @Range: 0 45
    // @Increment: 1
    // @User: User
    GSCALAR(level_roll_limit,              "LEVEL_ROLL_LIMIT",   5),

    // @Param: LAND_PITCH_CD
    // @DisplayName: ��½������
    // @Description: ��û�п��ټƵķɻ��Զ���½ʱ��ʹ�õĸ����ֶȣ��ٷ�֮һ�ȣ���
    // @Units: �ֶ�
    // @User: Advanced
    ASCALAR(land_pitch_cd,          "LAND_PITCH_CD",  0),

    // @Param: LAND_FLARE_ALT
    // @DisplayName: ��½ƽƮ�߶�
    // @Description: �Զ���½ʱ����ʲô�߶�������ͷ���򲢿�ʼƽƮ��LAND_PITCH_CD�趨����½�����Ƕ�
    // @Units: ��
    // @Increment: 0.1
    // @User: Advanced
    GSCALAR(land_flare_alt,          "LAND_FLARE_ALT",  3.0),

    // @Param: LAND_FLARE_SEC
    // @DisplayName: ��½ƽƮʱ��
    // @Description: ����½�㻹���ж೤ʱ��ʱ�����������ƽƮ����LAND_PITCH_CD�趨�ĸ����Ƕȡ�
    // @Units: ��
    // @Increment: 0.1
    // @User: Advanced
    GSCALAR(land_flare_sec,          "LAND_FLARE_SEC",  2.0),

	// @Param: NAV_CONTROLLER
	// @DisplayName: N����������ѡ��
	// @Description: ����ʹ��ʲô��������ϵͳ����ǰֻ��һ��L1��ѡ��δ�����ܻ�������ʵ���Ե�ѡ�
	// @Values: 0:Ĭ��,1:L1������
	// @User: Standard
	GSCALAR(nav_controller,          "NAV_CONTROLLER",   AP_Navigation::CONTROLLER_L1),

    // @Param: ALT_MIX
    // @DisplayName: GPS�����ѹ���߱���
    // @Description: ���GPS�߶Ⱥ���ѹ�߶ȵļ���Ȩ�ر�����0Ϊ��������GPS��1Ϊ��������ѹ��ǿ�ҽ��鲻Ҫ����Ĭ��ֵ1��Ҳ��Ҫ����ʹ����ѹ���ߣ���ΪGPS����ʵ�ڲ��ɿ�����Ȼ���������и��߾��ȵ�GPS���������ڼ��������ϵĸ߿�������Ͷ�ŷɻ���
    // @Units: �ٷֱ�
    // @Range: 0 1
    // @Increment: 0.1
    // @User: Advanced
    GSCALAR(altitude_mix,           "ALT_MIX",        ALTITUDE_MIX),

    // @Param: ALT_CTRL_ALG
    // @DisplayName: �߶ȿ����㷨
    // @Description: ���Ʒ��и߶���ʲô�㷨��Ĭ�ϵ�0����ݻ���ѡ������ʵ��㷨����ǰ���Ĭ�ϵ��㷨ʹ�õ���TECS�����嶯������ϵͳ����δ���᲻��ʱ������ʵ���Ե����㷨��
    // @Values: 0:�Զ�
    // @User: Advanced
    GSCALAR(alt_control_algorithm, "ALT_CTRL_ALG",    ALT_CONTROL_DEFAULT),

    // @Param: ALT_OFFSET
    // @DisplayName: �߶�ƫ����
    // @Description: ��ִ���Զ����У�Auto������ʱ�����Ŀ��߶ȡ��������ʹ��ȫ��ĺ��θ߶ȵ������
    // @Units: ��
    // @Range: -32767 32767
    // @Increment: 1
    // @User: Advanced
    GSCALAR(alt_offset, "ALT_OFFSET",                 0),

    // @Param: WP_RADIUS
    // @DisplayName: ����뾶
    // @Description: ������뺽������뾶���룬���ڴ˾���֮�ھ���������Ϊ�Ѿ��ִﺽ�㡣Ϊ�˷�ֹ�ɻ��ڵִﵱǰ����ʱ����Ϊ��·��ֱ���ϸ����㣬������˺��㵼�·ɻ��ᷴ����Ȧ���������õ����뾶����ߣ�ֻҪ�����������Ѿ��ִﺽ�㡣ע�⣬��һ������ǰ���������������ܻ��������������뾶֮��ſ���ת���������ת��ǶȵĴ�С�͵�ǰ�ɻ��ٶȡ����������������ϴ��ڷɻ�������ת��뾶��������������������ȷ����������������������������С���ͻ����ת����ȵ�����
    // @Units: Meters
    // @Range: 1 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(waypoint_radius,        "WP_RADIUS",      WP_RADIUS_DEFAULT),

    // @Param: WP_MAX_RADIUS
    // @DisplayName: �������뾶
    // @Description: ����һ���ຽ������������︨��ȷ�ϵִﺽ�㡣������������ڡ���Խ����ߡ����߼�ȥ��Ϊ�����Ѿ��ִ������ͨ���Զ����ƣ��������Ӧ����Ϊ0�����Ƿɻ�ֻ�ǽӽ�����İ뾶��������Ȧ��ͼ�ִﺽ��ʱ���Ž����޸Ĵ˲����� ����ɻ���ת��뾶��������趨ֵ�����ǻ���ɷɻ�������Ȧ��
    // @Units: ��
    // @Range: 0 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(waypoint_max_radius,        "WP_MAX_RADIUS",      0),

    // @Param: WP_LOITER_RAD
    // @DisplayName: ����뾶
    // @Description: ����ɻ��ڽ��ж������ʱ�����������ĵİ뾶���롣�������Ϊ��ֵ�����Ը���ֵ������ʱ����С�
    // @Units: ��
    // @Range: -32767 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(loiter_radius,          "WP_LOITER_RAD",  LOITER_RADIUS_DEFAULT),

#if GEOFENCE_ENABLED == ENABLED
    // @Param: FENCE_ACTION
    // @DisplayName: ����Χ����Ķ���
    // @Description: ����Χ����������ô�졣 ����Ϊ0�������κζ���������Ϊ1ʱ����GUIDEDģʽ, ͬʱĿ�꺽���ΪΧ�����ص㣻����Ϊ2ʱֻ���棬�����κζ�����3�����GUIDEDģʽ�������ֶ����ſ��ơ�
    // @Values: 0:����Ӧ,1:Guidedģʽ,2:ֻ����,3:�ֶ����ŵ�Guidedģʽ
    // @User: Standard
    GSCALAR(fence_action,           "FENCE_ACTION",   0),

    // @Param: FENCE_TOTAL
    // @DisplayName: Χ������
    // @Description: ��ǰ���õ�Χ����������
    // @User: Advanced
    GSCALAR(fence_total,            "FENCE_TOTAL",    0),

    // @Param: FENCE_CHANNEL
    // @DisplayName: Χ��ң��ͨ��
    // @Description: ����Χ�����ܵ�RCң��ͨ����PWM����1750������Χ����
    // @User: Standard
    GSCALAR(fence_channel,          "FENCE_CHANNEL",  0),

    // @Param: FENCE_MINALT
    // @DisplayName: Χ����С�߶�
    // @Description: ����Χ�����ܵ���С�߶����ơ�
    // @Units: ��
    // @Range: 0 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(fence_minalt,           "FENCE_MINALT",   0),

    // @Param: FENCE_MAXALT
    // @DisplayName: Χ�����߶�
    // @Description: ����Χ�����ܵ����߶ȡ�
    // @Units: ��
    // @Range: 0 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(fence_maxalt,           "FENCE_MAXALT",   0),

    // @Param: FENCE_RETALT
    // @DisplayName: Χ���������ظ߶�
    // @Description: ����Χ���������󣬷ɻ������ص�ʲô�߶ȣ�0Ϊ�ص�Χ�������߶Ⱥ���С�߶ȵ��м�㡣
    // @Units: ��
    // @Range: 0 32767
    // @Increment: 1
    // @User: Standard
    GSCALAR(fence_retalt,           "FENCE_RETALT",   0),

    // @Param: FENCE_AUTOENABLE
    // @DisplayName: Χ���Զ�����
    // @Description: Χ���Զ��������ܣ�����Ϊ1ʱ��Χ�����Զ����ʱ�򿪣����ڿ�ʼ�Զ�����ʱ�رա����鲻Ҫ��Ŀ�ӷ���ʱʹ�ã�ʵ��Ҫ�ã�����ͨ�����أ�FENCE_CHANNEL��������Χ�����������
    // @Values: 0:��ֹ�Զ�����,1:�Զ�����
    // @User: Standard
    GSCALAR(fence_autoenable,       "FENCE_AUTOENABLE", 0),

    // @Param: FENCE_RET_RALLY
    // @DisplayName: Χ�����ؼ����
    // @Description: ����Χ�����Ƿ񷵻ؼ���㣬1Ϊ�򿪴˹��ܣ����û�����ü���㣬���᷵��home point��
    // @Values: 0:���س�����,1:��������ļ����
    // @User: Standard
    GSCALAR(fence_ret_rally,        "FENCE_RET_RALLY",  0),     
#endif

    // @Param: STALL_PREVENTION
    // @DisplayName: ��ֹʧ��
    // @Description: �����������������ֹʧ�ٵĹ��ܣ����ܰ������Ƶ����µĲ���ǶȺ����ת��ʱ����С���٣���Щ���ƶ��ǻ�����תʱ�Ŀ����������أ������������������ȷ���õ� ARSPD_FBW_MIN ��ֵ��ע�⣬����ɻ�û�п��ټƣ���ֹʧ�ٹ��ܽ�ʹ�û��ڵ��ٺ��������������٣������Զ���ת��Ӧ�� ����ϳɵĿ��ٿ��ܻ᲻��ȷ��������û�п��ټƵ�����£����ܾ�����Ϊ�����������Ч�ء�
    // @Values: 0:����,1:����
    // @User: Standard
    ASCALAR(stall_prevention, "STALL_PREVENTION",  1),

    // @Param: ARSPD_FBW_MIN
    // @DisplayName: ��С����
    // @Description: �����Զ����ſ��Ƶķ���ģʽ�У����������С���١������ֵӦ����Ϊ���ڷɻ�ʧ���ٶȵ�20%���ң�ͬʱ�������Ҳ������STALL_PREVENTION������
    // @Units: ��/��
    // @Range: 5 100
    // @Increment: 1
    // @User: Standard
    ASCALAR(airspeed_min, "ARSPD_FBW_MIN",  AIRSPEED_FBW_MIN),

    // @Param: ARSPD_FBW_MAX
    // @DisplayName: ������
    // @Description: �������Զ����ſ��Ƶķ���ģʽ�У�������������١���Ӧ��ȷ�������ֵ�㹻����ARSPD_FBW_MIN �Ĳ���ֵ������֤�㹻�ĸ߶ȺͿ��ٿ��������������ֵ����Ҫ���� ARSPD_FBW_MIN��ֵ50%���ϡ�
    // @Units: ��/��
    // @Range: 5 100
    // @Increment: 1
    // @User: Standard
    ASCALAR(airspeed_max, "ARSPD_FBW_MAX",  AIRSPEED_FBW_MAX),

    // @Param: FBWB_ELEV_REV
    // @DisplayName: FBWģʽ�������淴��
    // @Description: ��FBWB��CRUISEģʽ�У������淴������Ϊ0ʱ�������������˽��ή�͸߶ȣ�����Ϊ1ʱ��������������Ϊ�����߶ȡ�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(flybywire_elev_reverse, "FBWB_ELEV_REV",  0),

#if AP_TERRAIN_AVAILABLE
    // @Param: TERRAIN_FOLLOW
    // @DisplayName: ʹ�õ��θ���
    // @Description: ����������CRUISEģʽ, FBWBģʽ, RTL�ͼ����ȷ���ģʽʹ�õ��θ��湦�ܡ�ʹ�����������Ҫ���� TERRAIN_ENABLE Ϊ1���⽫����ӵ���վ��õ������ݣ�����Ҫ����վ֧�ַ��͵������ݵ��ɿء�������ʹ�õ��θ��湦��ʱ��CRUISE��FBWB����ģʽ�����ַɻ��ڵ��θ߶�֮�ϣ�������home��߶�֮�ϣ�����ζ����ʱ���еĸ߶ȿ��ܻ�����ڳ�����߶ȡ� �ڷ��أ�RTL)ģʽ�£��������ʵ�ʸ߶ȼ������ڵ��θ߶�֮�ϡ������ĸ߶�Ҳ�ᱻ���õ����θ߶����ϡ������У�����ʵ�ʸ߶��Ǹ���home�㣬���Ǹ��ڵ��Σ�����Ԥ���ں�����������ʾ���Ҳ���Ӱ�����ķ�������Ҫʹ�õ��θ��湦�ܣ��ڵ���վ�滮����ʱ����Ҫ������������Ϊ���θ߶Ⱥ��㡣
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(terrain_follow, "TERRAIN_FOLLOW",  0),

    // @Param: TERRAIN_LOOKAHD
    // @DisplayName: ����Ԥ��
    // @Description: ������Ƶ��θ�����ǰ�����Զ�ľ��룬��ȷ��������ǰ���ĵ��εĸ߶�֮�ϡ�0ֵΪ��Ԥ�У����Կ�������ֻ���ٷɻ�֮�µĵ��Ρ���AUTOģʽ��Ҳ�������һ���������Ԥ�С�
    // @Range: 0 10000
    // @Units: ��
    // @User: Standard
    GSCALAR(terrain_lookahead, "TERRAIN_LOOKAHD",  2000),
#endif

    // @Param: FBWB_CLIMB_RATE
    // @DisplayName: FBW-B�߶ȸı�����
    // @Description: ��FBWB��CRUISEģʽ�У�ʹ�����������ʱ������ı�߶ȵ��ٱȡ�ע�⣬�ɻ���ʵ���������ʿ��Ե��������ֵ����ȡ���ڿ��ٺ����ſ��Ƶ����á����磬����ΪĬ�ϵ�2m/s������������10�룬��������20�ס�
    // @Range: 1-10
	// @Increment: 0.1
    // @User: Standard
    GSCALAR(flybywire_climb_rate, "FBWB_CLIMB_RATE",  2.0f),

    // @Param: THR_MIN
    // @DisplayName: ��С��������
    // @Description: �ɿؿ��Ƶ���С���ſ����������ٷֱȣ��������׶ε��Զ�����Ӧ������Ϊ0��
    // @Units: �ٷֱ�
    // @Range: 0 100
    // @Increment: 1
    // @User: Standard
    ASCALAR(throttle_min,           "THR_MIN",        THROTTLE_MIN),

    // @Param: THR_MAX
    // @DisplayName: �����������
    // @Description: �ɿؿ��Ƶ�������ſ����������ٷֱȣ���
    // @Units: �ٷֱ�
    // @Range: 0 100
    // @Increment: 1
    // @User: Standard
    ASCALAR(throttle_max,           "THR_MAX",        THROTTLE_MAX),

    // @Param: TKOFF_THR_MAX
    // @DisplayName: ������������
    // @Description: �Զ����ʱ���õ�����������������Ϊ0����Ӧ�� THR_MAX �������Զ�����ʱ������������� �趨����������
    // @Units: �ٷֱ�
    // @Range: 0 100
    // @Increment: 1
    // @User: Advanced
    GSCALAR(takeoff_throttle_max,   "TKOFF_THR_MAX",        0),

    // @Param: THR_SLEWRATE
    // @DisplayName: ���ű仯����
    // @Description: ÿ���������仯�İٷֱȡ�������Ϊ10����ô������ʱ�����ŵ������ٶȲ��ᳬ������������10%/�롣
    // @Units: �ٷֱ�
    // @Range: 0 127
    // @Increment: 1
    // @User: Standard
    ASCALAR(throttle_slewrate,      "THR_SLEWRATE",   100),

    // @Param: FLAP_SLEWRATE
    // @DisplayName: ����仯����Flap slew rate
    // @Description: ������������仯���ʰٷֱ�/�롣���磬�趨25�����ý�����һ��֮�ڵĶ����ٶȣ��������������г̵�25%��0ֵΪ���޶����ʡ�
    // @Range: 0 100
    // @Increment: 1
    // @User: Advanced
    GSCALAR(flap_slewrate,          "FLAP_SLEWRATE",   75),

    // @Param: THR_SUPP_MAN
    // @DisplayName: �ֶ�����ֱͨ�Զ�����
    // @Description: ���Զ�����ģʽ�£����ɿ���Ҫ��������ʱ��ͨ����ǿ�Ƶ�0���š�����������ѡ��������ƽ����ֶ����ſ�����ȡ�����������ͷ������Ϻ����ô����������������ǰһֱ�ֶ����Ʊ��ֵ��١�
	// @Values: 0:����,1:����
    // @User: Advanced
    GSCALAR(throttle_suppress_manual,"THR_SUPP_MAN",   0),

    // @Param: THR_PASS_STAB
    // @DisplayName: ����ģʽ�е�����ֱͨ
    // @Description: ���ѡ�����������ʹ�ã���ô�� STABILIZE, FBWA �� ACRO ����ģʽ�У�RC���ſ��ƽ�ֱͨ������������ܵ���С������ THR_MIN �����������THR_MAX �����ơ��⽫��ʹ�����ͷ������ķ��ſ������÷ǳ����ã���Ϊ�����������ŵ�����Сʱ��Ӱ�졣ͬʱ�����ڱȽ϶̵��ܵ��������õ綯�ɻ���ȫ���ſ������գ����ڿ����Զ����ſ���ʱ�������޶���������������У����ڳ�ʱ�䴦������״̬ʱ�����Խ��͵�����أ���ʡ������
	// @Values: 0:����,1:����
    // @User: Advanced
    GSCALAR(throttle_passthru_stabilize,"THR_PASS_STAB",   0),

    // @Param: THR_FAILSAFE
    // @DisplayName: ����ʧ�ر���
    // @Description: ������ͨ����������ʱ���Ƿ�ʹ��ʧ�ر������ܡ�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(throttle_fs_enabled,    "THR_FAILSAFE",   THROTTLE_FAILSAFE),


    // @Param: THR_FS_VALUE
    // @DisplayName: ����ʧ�ر�������ֵ
    // @Description: ������ͨ��PWMֵ���ڶ���ʱ������ʧ�ر������ܡ�
    // @Range: 925 1100
    // @Increment: 1
    // @User: Standard
    GSCALAR(throttle_fs_value,      "THR_FS_VALUE",   THROTTLE_FS_VALUE),

    // @Param: TRIM_THROTTLE
    // @DisplayName: Ѳ�����Űٷֱ�
    // @Description: ��������ʱ��Ŀ�����Űٷֱȡ�
    // @Units: �ٷֱ�
    // @Range: 0 100
    // @Increment: 1
    // @User: Standard
    ASCALAR(throttle_cruise,        "TRIM_THROTTLE",  THROTTLE_CRUISE),

    // @Param: THROTTLE_NUDGE
    // @DisplayName: ��������
    // @Description: ���������ѡ��ʱ�����κ����Զ����ŵķ���ģʽ�У�����ҡ�˵�λ�þ����˳������ӻ�����������ı仯�����ʹ���˿��ټƣ�����ҡ�˵�λ�ó���50%ʱ���ɿؽ��������ӿ���ֱ���ﵽARSPD_FBW_MAX�������趨�������١����û�п��ټƣ�����ҡ���Ƶ�ʲôλ�ã��ɿؾ����ӵ��ת�ٵ�ʲôλ�á�
    // @Values: 0:����,1:����
    // @User: Standard
    // @User: Standard
    GSCALAR(throttle_nudge,         "THROTTLE_NUDGE",  1),

    // @Param: FS_SHORT_ACTN
    // @DisplayName: ��ʱʧ�ر�������
    // @Description: ��AUTO, GUIDED �� LOITERģʽ�£��̳�ʱ FS_SHORT_TIMEOUT �����趨��ʱ��ﵽ��������ʧ�ر������ѡ���ʱʧ�ر������Ա���ʧң���źţ��ο�THR_FS_VALUE�������Ͷ�ʧ����վ���ƣ��ο�FS_GCS_ENABL���������������������Ϊ1���������Ⱥ��ֶ���ģʽ�£���ʱʧ�ر������Ĵ������л�����ģʽ��CIRCLEģʽ���������Ϊ2�����л���FBWAģʽ������������ģʽ�£�����ATUO��GUIDEDģʽ�����������Ϊ0����ʱʧ�ر����Ĵ�������ı����ģʽ�������Ϊ1������ΪCIRCLEģʽ�������Ϊ2������ΪFBWAģʽ���ο� FS_LONG_ACTN �� FS_LONG_TIMEOUT�����������Ķ�����
    // @Values: 0:��������,1:��Ȧ/���س�����,2:����
    // @User: Standard
    GSCALAR(short_fs_action,        "FS_SHORT_ACTN",  SHORT_FAILSAFE_ACTION),

    // @Param: FS_SHORT_TIMEOUT
    // @DisplayName: ��ʱʧ�ر�����ʱ
    // @Description: ʧ�ر���������ֺ󣬶೤ʱ�䴥����ʱʧ�ر���������Ĭ��Ϊ1.5�롣
    // @Units: ��
    // @Range: 1 100
    // @Increment: 0.5
    // @User: Standard
    GSCALAR(short_fs_timeout,        "FS_SHORT_TIMEOUT", 1.5f),

    // @Param: FS_LONG_ACTN
    // @DisplayName: ��ʱʧ�ر�������
    // @Description: ��ʱʧ�ر�����ʱ��ﵽ�󣬻��ȡ�Ķ������������Ϊ0�����ᴥ���κζ����������Ϊ1���������ؼң�RTL��ģʽ�������Ϊ2��������FBWAģʽ��
    // @Values: 0:����,1:����,2:����
    // @User: Standard
    GSCALAR(long_fs_action,         "FS_LONG_ACTN",   LONG_FAILSAFE_ACTION),

    // @Param: FS_LONG_TIMEOUT
    // @DisplayName: ��ʱʧ�ر�����ʱ
    // @Description: ʧ�ر���������ֺ󣬶೤ʱ�䴥����ʱʧ�ر���������Ĭ��Ϊ20�롣
    // @Units: ��
    // @Range: 1 300
    // @Increment: 0.5
    // @User: Standard
    GSCALAR(long_fs_timeout,        "FS_LONG_TIMEOUT", 20),

    // @Param: FS_BATT_VOLTAGE
    // @DisplayName: ��ѹ����
    // @Description: ����ʧ�ر����ĵ�ѹ������Ϊ0Ϊ���ô˹��ܡ������д�˾������ֵ������ѹһ�����ڴ���ֵ����10���ӣ��ɿؽ����뷵�أ�RTL��ģʽ��
    // @Units: ����
    // @Increment: 0.1
    // @User: Standard
    GSCALAR(fs_batt_voltage,        "FS_BATT_VOLTAGE", 0),

    // @Param: FS_BATT_MAH
    // @DisplayName: ��ص�������������ʱ��
    // @Description: �����趨�ĵ�����������ᴥ��ʧ�ر�������Ϊ0���ô˹��ܡ�������ʣ�������������õ���ֵ�����������������أ�RTL��ģʽ��
    // @Units: ����ʱ
    // @Increment: 50
    // @User: Standard
    GSCALAR(fs_batt_mah,            "FS_BATT_MAH", 0),

    // @Param: FS_GCS_ENABL
    // @DisplayName: ����վʧ�ر���
    // @Description: �Ƿ��������վ���ݴ����ʧ�ر������ܡ����FS_LONG_TIMEOUT�����趨��ʱ����Ȼû��MAVLink�����źţ�������ʧ�ر�������������������������ã�����Ϊ1ʱ������ɿ��ղ���MAVLink�����źţ�������ʧ�ر���������Ϊ2��ζ�Ų������ղ����ɿ������źţ������޷����շɿصĸ������ݣ����ᴥ��ʧ�ر������������� RADIO_STATUS���remrssi����ʾΪ0. (һ���������ڵ��������ݵĵ���վ��ɿض˵����ߵ�������ɵģ������棺�������ѡ����ܻ��ڵ�����Ե�ʱ����ɵ����������������Ӧ���ý���Ҫ��ARMING_REQUIRED����Ϊ���� 
    // @Values: 0:����,1:������,2:��������REMRSSI
    // @User: Standard
    GSCALAR(gcs_heartbeat_fs_enabled, "FS_GCS_ENABL", GCS_FAILSAFE_OFF),

    // @Param: FLTMODE_CH
    // @DisplayName: ����ģʽ�л�ͨ��
    // @Description: ����ģʽ�л���ʹ�õ�ң��ͨ����
    // @User: Advanced
    GSCALAR(flight_mode_channel,    "FLTMODE_CH",     FLIGHT_MODE_CHANNEL),

    // @Param: FLTMODE1
    // @DisplayName: ����ģʽ1
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    // @Description: λ��1 �ķ���ģʽ(910 to 1230 and above 2049)
    GSCALAR(flight_mode1,           "FLTMODE1",       FLIGHT_MODE_1),

    // @Param: FLTMODE2
    // @DisplayName: ����ģʽ2
    // @Description: λ��2 �ķ���ģʽ (1231 to 1360)
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    GSCALAR(flight_mode2,           "FLTMODE2",       FLIGHT_MODE_2),

    // @Param: FLTMODE3
    // @DisplayName: ����ģʽ3
    // @Description: λ��3 �ķ���ģʽ (1361 to 1490)
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    GSCALAR(flight_mode3,           "FLTMODE3",       FLIGHT_MODE_3),

    // @Param: FLTMODE4
    // @DisplayName: ����ģʽ4
    // @Description:λ��4 �ķ���ģʽ (1491 to 1620)
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    GSCALAR(flight_mode4,           "FLTMODE4",       FLIGHT_MODE_4),

    // @Param: FLTMODE5
    // @DisplayName: ����ģʽ5
    // @Description: λ��5 �ķ���ģʽ (1621 to 1749)
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    GSCALAR(flight_mode5,           "FLTMODE5",       FLIGHT_MODE_5),

    // @Param: FLTMODE6
    // @DisplayName: ����ģʽ6
    // @Description: λ��6 �ķ���ģʽ (1750 to 2049)
    // @Values: 0:�ֶ�,1:��Ȧ,2:����,3:����,4:�ؼ�,5:FBWA,6:FBWB,7:Ѳ��,8:�Զ�����,10:�Զ�����,11:����,12:����,15:����
    // @User: Standard
    GSCALAR(flight_mode6,           "FLTMODE6",       FLIGHT_MODE_6),

    // @Param: LIM_ROLL_CD
    // @DisplayName: ������ǶȾ���
    // @Description: ������������Ĳ���ȳ����趨ֵ�󱨾���
    // @Units: �ֶ�
    // @Range: 0 9000
    // @Increment: 1
    // @User: Standard
    GSCALAR(roll_limit_cd,          "LIM_ROLL_CD",    HEAD_MAX_CENTIDEGREE),

    // @Param: LIM_PITCH_MAX
    // @DisplayName: ��������ǶȾ���
    // @Description: �����Ƕȳ����趨ֵ�󱨾���
    // @Units: �ֶ�
    // @Range: 0 9000
    // @Increment: 1
    // @User: Standard
    ASCALAR(pitch_limit_max_cd,     "LIM_PITCH_MAX",  PITCH_MAX_CENTIDEGREE),

    // @Param: LIM_PITCH_MIN
    // @DisplayName: ��С�½��ǶȾ���
    // @Description: �½��Ƕȳ����趨ֵ�󱨾���
    // @Units: centi-Degrees
    // @Range: -9000 0
    // @Increment: 1
    // @User: Standard
    ASCALAR(pitch_limit_min_cd,     "LIM_PITCH_MIN",  PITCH_MIN_CENTIDEGREE),

    // @Param: ACRO_ROLL_RATE
    // @DisplayName: �ؼ�ģʽ�Ĳ�������
    // @Description: ���ؼ�ģʽ�£�����ת��ʱ���Ĳ������ʡ�
    // @Units: ��/��
    // @Range: 10 500
    // @Increment: 1
    // @User: Standard
    GSCALAR(acro_roll_rate,          "ACRO_ROLL_RATE",    180),

    // @Param: ACRO_PITCH_RATE
    // @DisplayName: �ؼ�ģʽ�ĸ�������
    // @Description: ���ؼ�ģʽ�£�����������ʱ�����������ʡ�
    // @Units: ��/��
    // @Range: 10 500
    // @Increment: 1
    // @User: Standard
    GSCALAR(acro_pitch_rate,          "ACRO_PITCH_RATE",  180),

    // @Param: ACRO_LOCKING
    // @DisplayName: �ؼ�ģʽ�߶�����
    // @Description: �������ѡ����ؼ�ģʽ���ɿ�ң��ҡ�ˣ����������ɻ��ĵ�ǰ�߶��ϡ�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(acro_locking,             "ACRO_LOCKING",     0),

    // @Param: GROUND_STEER_ALT
    // @DisplayName: ����ת��߶�
    // @Description: ������ʲô�߶��ϣ���ʼ�ڷ������ʹ�õ���ת��������������򡣷�0����ֵ����������STEER2SRV����������home�ĸ߶��޶�֮����ת�����ơ�
    // @Units: ��
    // @Range: -100 100
    // @Increment: 0.1
    // @User: Standard
    GSCALAR(ground_steer_alt,         "GROUND_STEER_ALT",   0),

    // @Param: GROUND_STEER_DPS
    // @DisplayName: ����ת������
    // @Description: ��RC����������ʱ��Ӧ���ڵ���ת��Ķ�������Ϊ���ٶ�/�롣
    // @Units: ��/��
    // @Range: 10 360
    // @Increment: 1
    // @User: Advanced
    GSCALAR(ground_steer_dps,         "GROUND_STEER_DPS",  90),

    // @Param: TRIM_AUTO
    // @DisplayName: �Զ��м�λ����
    // @Description: �Ƿ�������ֶ�ģʽ��manual���л�����������ģʽ��ʱ�򣬰ѵ�ǰ����������ͷ�����RCң�ظ�λ�ã�����Ϊ��������ģʽ��Ӧ��ң�ظ����ĵ㡣����ʹ�õ�ǰ�����ң�ظ˵�PWMֵ����ΪRC1_TRIM, RC2_TRIM �� RC4_TRIM ��ֵ��Ĭ��Ϊ0����ΪĳЩ���ֲ�֪���������ʱ���ᵼ����������������ѡ������ֶ�ģʽ��ɣ������ɻ���ʲô��Ӧ��Ȼ���е�FBW-Aģʽ�����м�㣬Ȼ�����ֶ�ģʽ���ٴε�����ÿ���л��ֶ�ģʽ��ʱ��APM�������������Ϊ�м�㡣ȫ�����úú󣬿��Խ��ô˹��ܡ�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(auto_trim,              "TRIM_AUTO",      AUTO_TRIM),

    // @Param: ELEVON_MIXING
    // @DisplayName: ����������
    // @Description: �Ƿ������������������������ͨ����ʹ�û�ء����ֻ�������ͨ��ʹ�����������أ���ELEVON_OUTPUT�������á�
    // @Values: 0:����,1:����
    // @User: User
    GSCALAR(mix_mode,               "ELEVON_MIXING",  ELEVON_MIXING),

    // @Param: ELEVON_REVERSE
    // @DisplayName: ����������
    // @Description: �������������ء�
    // @Values: 0:����,1:����
    // @User: User
    GSCALAR(reverse_elevons,        "ELEVON_REVERSE", ELEVON_REVERSE),


    // @Param: ELEVON_CH1_REV
    // @DisplayName: ��������1ͨ������
    // @Description: ������������ͨ��1��
    // @Values: -1:����,1:����
    // @User: User
    GSCALAR(reverse_ch1_elevon,     "ELEVON_CH1_REV", ELEVON_CH1_REVERSE),

    // @Param: ELEVON_CH2_REV
    // @DisplayName: ��������2ͨ������
    // @Description: ������������ͨ��2.
    // @Values: -1:����,1:����
    // @User: User
    GSCALAR(reverse_ch2_elevon,     "ELEVON_CH2_REV", ELEVON_CH2_REVERSE),

    // @Param: VTAIL_OUTPUT
    // @DisplayName: V��β���������
    // @Description: Vβ�Ŀ���ģʽ������ʹ�õĻ���APM���������ͷ���ͨ�����������Ͽ��ơ�������4�ֲ�ͬ�Ļ��ģʽ�������Vβ�ɻ�β����2������ֱ���п��ơ�ע�⣺��������RC����Ϊ��·ֱͨ��
    // @Values: 0:����,1:����,2:����,3:����,4:����
    // @User: User
    GSCALAR(vtail_output,           "VTAIL_OUTPUT",  0),

    // @Param: ELEVON_OUTPUT
    // @DisplayName: ���������������
    // @Description: ʹ��������������������ͨ���Ļ�ء��������ʹ�ã�APM���Ը����������ͨ�����������ء������ṩ4�ֲ�ͬ�Ļ��ģʽ��ʹ�����漯�Ͻ�������������ϵͳ��ע�⣺���ﲻ��ʹ��RCң���ź�ֱͨ���������ˣ�����ͨ��8��������Ϊ�ֶ���manual����ͬʱҪ�� MIXING_GAIN ���л������ѡ��
    // @Values: 0:����,1:����,2:����,3:����,4:����
    // @User: User
    GSCALAR(elevon_output,           "ELEVON_OUTPUT",  0),

    // @Param: MIXING_GAIN
    // @DisplayName: �������
    // @Description: ��Vβ����������Ļ��������档Ĭ��Ϊ0.5������ȷ�����û�ع��أ��������������ֻ��������ͨ���ﵽ���ޣ������ͨ�����ܱ��ֿ��ơ�Ӳ����ؾ�������Ϊ1.0�����棬�ö����Ӧ����, ���ǻ��й��ء������Vβ�����������ϵĶ��û���㹻�ķ�Ӧ�ٶȣ��Ϳ����ڴ�����������������������������Χ��900-2100΢�롣
    // @Range: 0.5 1.2
    // @User: User
    GSCALAR(mixing_gain,            "MIXING_GAIN",    0.5f),

    // @Param: SYS_NUM_RESETS
    // @DisplayName: ���ô���
    // @Description: APM������ô�����
    // @User: Advanced
    GSCALAR(num_resets,             "SYS_NUM_RESETS", 0),

    // @Param: LOG_BITMASK
    // @DisplayName: Log bitmask
    // @Description: ѡ����Ҫ�����Log�ļ����࣬��APM2�ϣ�ֻ��4MByte���棬���Բ�Ҫ����̫�����ࡣ��Log�������£� ATTITUDE_FAST=1, ATTITUDE_MEDIUM=2, GPS=4, PerformanceMonitoring=8, ControlTuning=16, NavigationTuning=32, Mode=64, IMU=128, Commands=256, Battery=512, Compass=1024, TECS=2048, Camera=4096, RCandServo=8192, Sonar=16384, Arming=32768, LogWhenDisarmed=65536��������log���ܵı��������뼴�ɴ洢��������ݡ�
    // @Values: 0:����,5190:APM2-Ĭ��,65535:PX4/Pixhawk-Ĭ��
    // @User: Advanced
    GSCALAR(log_bitmask,            "LOG_BITMASK",    DEFAULT_LOG_BITMASK),

    // @Param: RST_SWITCH_CH
    // @DisplayName: ���÷���ģʽͨ��
    // @Description: ����һ��RCͨ�������������趨����Χ��ǰ�����һ������ģʽ��
    // @User: Advanced
    GSCALAR(reset_switch_chan,      "RST_SWITCH_CH",  0),

    // @Param: RST_MISSION_CH
    // @DisplayName: ��������ͨ��
    // @Description: �������񵽵�һ�����RCͨ���趨��������趨��ͨ��PWMֵ����1750�����񽫱����á�0Ϊ���á�
    // @User: Advanced
    GSCALAR(reset_mission_chan,      "RST_MISSION_CH",  0),

    // @Param: TRIM_ARSPD_CM
    // @DisplayName: Ŀ�����
    // @Description: ��Autoģʽ�£������ٴﵽ���趨ֵ��ʱ�򣬽���ʼ��׼Ŀ�����С�
    // @Units: cm/s
    // @User: User
    GSCALAR(airspeed_cruise_cm,     "TRIM_ARSPD_CM",  AIRSPEED_CRUISE_CM),

    // @Param: SCALING_SPEED
    // @DisplayName: �ٶȲ�������
    // @Description: ���ٴﵽ������/��ʱ�����������ٶȼ��㡣ע�⣬���ĸò�����Ӱ�����е�P��I��D������
    // @Units: ��/��
    // @User: Advanced
    GSCALAR(scaling_speed,        "SCALING_SPEED",    SCALING_SPEED),

    // @Param: MIN_GNDSPD_CM
    // @DisplayName: ��С�����ٶ�
    // @Description: ʹ�ÿ��ټƿ��Ʒɻ�ʱ�����������С�����ٶȡ�
    // @Units: ����/��
    // @User: Advanced
    GSCALAR(min_gndspeed_cm,      "MIN_GNDSPD_CM",  MIN_GNDSPEED_CM),

    // @Param: TRIM_PITCH_CD
    // @DisplayName: �����Ƕ�ƫ����
    // @Description: �������������еĸ����м�㡣�����ڵ���ƽ�÷ɻ����е�����
    // @Units: �ֶ�
    // @User: Advanced
    GSCALAR(pitch_trim_cd,        "TRIM_PITCH_CD",  0),

    // @Param: ALT_HOLD_RTL
    // @DisplayName: ���ظ߶�
    // @Description: ���ص�������ĸ߶ȣ��⽫�Ƿɻ��ڷ���ʱ��׼�ĸ߶ȣ�Ҳ�ǻص��������㲢�����ĸ߶ȣ������Ϊ-1���ɻ���ʹ�õ�ǰ�߶Ƚ���RTLģʽ��ע�⣬����趨�˼���㣨rally point������ô������Ԥ��߶ȣ������滻���RTLģʽ��Ԥ��߶ȡ�
    // @Units: ����
    // @User: User
    GSCALAR(RTL_altitude_cm,        "ALT_HOLD_RTL",   ALT_HOLD_HOME_CM),

    // @Param: ALT_HOLD_FBWCM
    // @DisplayName: FBWBģʽ�µ���С���и߶�
    // @Description: ��FBW-B��CRUISE����ģʽ�£����Ƶ���ͷ��и߶ȣ�����ɻ��½�������趨ֵ���ɿػ��Զ���������ʹ�ɻ��������Ԥ�����С�߶ȡ�0Ϊ�����ơ�
    // @Units: ����
    // @User: User
    GSCALAR(FBWB_min_altitude_cm,   "ALT_HOLD_FBWCM", ALT_HOLD_FBW_CM),

    // @Param: MAG_ENABLE
    // @DisplayName: ����ʹ������
    // @Description: �Ƿ��������̣�ע�⣺���ѡ���COMPASS_USE�ǲ�ͬ�ġ��������õĵ͸жȵĸ�Ӧ��������������log�ļ���Ҫʹ�����̽��е��������������� COMPASS_USE Ϊ 1��
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(compass_enabled,        "MAG_ENABLE",     1),

    // @Param: FLAP_IN_CHANNEL
    // @DisplayName: ��������ͨ��
    // @Description: ʹ���ĸ�ң��ͨ�������ƽ�������趨��ĳ��ң��ͨ�������ƣ����ͨ������С������λ�õĿ����г̻���������ȵİٷֱȣ���������źŸ�������λ�õ��ź�ֵ����ʹ������򿪣���ɼ��ٰ�Ĺ��ܡ���ѡ����Ҫ������ø����ͨ��FUNCTION�������һ�������ܡ�����ң��ͨ�����Զ����������ʹ�ú󣬻��и�������Ľ������������������ͬʱ����FLAPERON_OUTPUT��Ľ������趨��
    // @User: User
    GSCALAR(flapin_channel,         "FLAP_IN_CHANNEL",  0),

    // @Param: FLAPERON_OUTPUT
    // @DisplayName: �����������
    // @Description: �Ƿ�����������ƽ�������������������������APM��ͨ���������FLAPERON1��FLAPERON2������FUNCTIONѡ����ĸ���ѡ����н����ص��ơ�������4�ֲ�ͬ�Ļ��ģʽ����Ӧ������͸���Ļ���ŷ�ϵͳ��ע�⣺���ﲻ��ʹ��RCң���ź�ֱͨ���������ˣ�������APM1��ͨ��8��ʹ���ֶ����ơ����ԣ������ʹ��APM1����Ҫ�����÷���ģʽ�Ŀ���ͨ����8���������ͨ����ͬʱҪע��Ի�ص����棨MIXING_GAIN�����������ʵĴ�С����������������������ELEVON_OUTPUT�� �� �����������棨ELEVON_MIXING�� ���й������á�
    // @Values: 0:����,1:����,2:����,3:����,4:����
    // @User: User
    GSCALAR(flaperon_output,        "FLAPERON_OUTPUT",  0),

    // @Param: FLAP_1_PERCNT
    // @DisplayName: ����1λ��
    // @Description: ��FLAP_1_SPEED������ֵ�������󣬽�������ʲôλ�ã��������İٷֱȣ���0Ϊ��ֹʹ�ý���
    // @Range: 0 100
    // @Units: �ٷֱ�
    // @User: Advanced
    GSCALAR(flap_1_percent,         "FLAP_1_PERCNT",  FLAP_1_PERCENT),

    // @Param: FLAP_1_SPEED
    // @DisplayName: ����1�����ٶ�
    // @Description: ��Ŀ����ٴ��������ֵʱ������FLAP_1_PERCNT����Ľ����ȡ�ע�⣬����ٶ�Ӧ�ô��ڻ����FLAP_2_SPEED��
    // @Range: 0 100
	// @Increment: 1
    // @Units: ��/��
    // @User: Advanced
    GSCALAR(flap_1_speed,           "FLAP_1_SPEED",   FLAP_1_SPEED),

    // @Param: FLAP_2_PERCNT
    // @DisplayName: ����2λ��
    // @Description: ��FLAP_2_SPEED������ֵ�������󣬽�������ʲôλ�ã��������İٷֱȣ���0Ϊ��ֹʹ�ý���
    // @Range: 0 100
	// @Units: �ٷֱ�
    // @User: Advanced
    GSCALAR(flap_2_percent,         "FLAP_2_PERCNT",  FLAP_2_PERCENT),

    // @Param: FLAP_2_SPEED
    // @DisplayName: ����2�����ٶ�
    // @Description: ��Ŀ����ٴ��������ֵʱ������FLAP_2_PERCNT����Ľ����ȡ�ע�⣬FLAP_1_SPEEDӦ�ô��ڻ����FLAP_2_SPEED��
    // @Range: 0 100
	// @Units: ��/��
	// @Increment: 1
    // @User: Advanced
    GSCALAR(flap_2_speed,           "FLAP_2_SPEED",   FLAP_2_SPEED),

    // @Param: LAND_FLAP_PERCNT
    // @DisplayName: ��½ʱ�������̶�
    // @Description:���Զ���½������ƽƮʱ�������İٷֱȡ�
    // @Range: 0 100
    // @Units: �ٷֱ�
    // @User: Advanced
    GSCALAR(land_flap_percent,     "LAND_FLAP_PERCNT", 0),

#if CONFIG_HAL_BOARD == HAL_BOARD_PX4
    // @Param: OVERRIDE_CHAN
    // @DisplayName: PX4IO override channel
    // @Description: If set to a non-zero value then this is an RC input channel number to use for testing manual control in case the main FMU microcontroller on a PX4 or Pixhawk fails. When this RC input channel goes above 1750 the FMU will stop sending servo controls to the PX4IO board, which will trigger the PX4IO board to start using its failsafe override behaviour, which should give you manual control of the aircraft. That allows you to test for correct manual behaviour without actually crashing the FMU. This parameter is normally only set to a non-zero value for ground testing purposes. When the override channel is used it also forces the PX4 safety switch into an armed state. This allows it to be used as a way to re-arm a plane after an in-flight reboot. Use in that way is considered a developer option, for people testing unstable developer code. Note that you may set OVERRIDE_CHAN to the same channel as FLTMODE_CH to get PX4IO based override when in flight mode 6. Note that when override is triggered the 6 auxillary output channels on Pixhawk will no longer be updated, so all the flight controls you need must be assigned to the first 8 channels.
    // @User: Advanced
    GSCALAR(override_channel,      "OVERRIDE_CHAN",  0),
#endif

    // @Param: RSSI_PIN
    // @DisplayName: RSSI�źŸ�Ӧ���
    // @Description: ѡ���Ǹ����������������RSSI��ѹ������Ĭ�ϵ����rssiΪ5v��ѹ��0Ϊ��С��
    // @Values: -1:����, 0:APM2 A0, 1:APM2 A1, 13:APM2 A13, 103:Pixhawk SBUS
    // @User: Standard
    GSCALAR(rssi_pin,            "RSSI_PIN",         -1),

    // @Param: RSSI_RANGE
    // @DisplayName: �������RSSI�ĵ�ѹ��Χ
    // @Description: �������RSSI�ĵ�ѹ��Χ
    // @Units: ����
    // @Values: 3.3:3.3V, 5.0:5V
    // @User: Standard
    GSCALAR(rssi_range,          "RSSI_RANGE",         5.0),

    // @Param: INVERTEDFLT_CH
    // @DisplayName: ����ң��ͨ��
    // @Description: ����ĳ��RC����ͨ�����Ƶ��ɡ�������Ϊĳ��ͨ���󣬸�ͨ��PWMֵһ������1750��APM����Ʒɻ���ת���е��ɡ�
    // @Values: 0:����,1:ͨ��1,2:ͨ��2,3:ͨ��3,4:ͨ��4,5:ͨ��5,6:ͨ��6,7:ͨ��7,8:ͨ��8
    // @User: Standard
    GSCALAR(inverted_flight_ch,     "INVERTEDFLT_CH", 0),

#if HIL_MODE != HIL_MODE_DISABLED
    // @Param: HIL_SERVOS
    // @DisplayName: HIL Servos enable
    // @Description: This controls whether real servo controls are used in HIL mode. If you enable this then the APM will control the real servos in HIL mode. If disabled it will report servo values, but will not output to the real servos. Be careful that your motor and propeller are not connected if you enable this option.
    // @Values: 0:Disabled,1:Enabled
    // @User: Advanced
    GSCALAR(hil_servos,            "HIL_SERVOS",      0),

    // @Param: HIL_ERR_LIMIT
    // @DisplayName: Limit of error in HIL attitude before reset
    // @Description: This controls the maximum error in degrees on any axis before HIL will reset the DCM attitude to match the HIL_STATE attitude. This limit will prevent poor timing on HIL from causing a major attitude error. If the value is zero then no limit applies.
    // @Units: degrees
    // @Range: 0 90
    // @Increment: 0.1
    // @User: Advanced
    GSCALAR(hil_err_limit,         "HIL_ERR_LIMIT",   5),
#endif

    // @Param: RTL_AUTOLAND
    // @DisplayName: ���ز��Զ���½
    // @Description: ���س�������Զ�ִ����½�������У�����Ҫ�� DO_LAND_START �������ò�����Ϊһ����½���С���ǰλ�û������������½���С�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(rtl_autoland,         "RTL_AUTOLAND",   0),

    // barometer ground calibration. The GND_ prefix is chosen for
    // compatibility with previous releases of ArduPlane
    // @Group: GND_
    // @Path: ../libraries/AP_Baro/AP_Baro.cpp
    GOBJECT(barometer, "GND_", AP_Baro),

    // GPS driver
    // @Group: GPS_
    // @Path: ../libraries/AP_GPS/AP_GPS.cpp
    GOBJECT(gps, "GPS_", AP_GPS),

#if CAMERA == ENABLED
    // @Group: CAM_
    // @Path: ../libraries/AP_Camera/AP_Camera.cpp
    GOBJECT(camera,                  "CAM_", AP_Camera),
#endif

    // @Group: ARMING_
    // @Path: ../libraries/AP_Arming/AP_Arming.cpp
    GOBJECT(arming,                 "ARMING_", AP_Arming),

    // @Group: RELAY_
    // @Path: ../libraries/AP_Relay/AP_Relay.cpp
    GOBJECT(relay,                  "RELAY_", AP_Relay),

    // @Group: RNGFND
    // @Path: ../libraries/AP_RangeFinder/RangeFinder.cpp
    GOBJECT(rangefinder,            "RNGFND", RangeFinder),

    // @Param: RNGFND_LANDING
    // @DisplayName: ��½ʱʹ�ò����
    // @Description: ������������������Զ���½ʱʹ�ò���ǡ�����ǽ����ڽ��������ƽƮʱ���ᱻʹ�á�
    // @Values: 0:����,1:����
    // @User: Standard
    GSCALAR(rangefinder_landing,    "RNGFND_LANDING",   0),

#if AP_TERRAIN_AVAILABLE
    // @Group: TERRAIN_
    // @Path: ../libraries/AP_Terrain/AP_Terrain.cpp
    GOBJECT(terrain,                "TERRAIN_", AP_Terrain),
#endif

    // RC channel
    //-----------
    // @Group: RC1_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp
    GGROUP(rc_1,                    "RC1_", RC_Channel),

    // @Group: RC2_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp
    GGROUP(rc_2,                    "RC2_", RC_Channel),

    // @Group: RC3_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp
    GGROUP(rc_3,                    "RC3_", RC_Channel),

    // @Group: RC4_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp
    GGROUP(rc_4,                    "RC4_", RC_Channel),

    // @Group: RC5_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_5,                    "RC5_", RC_Channel_aux),

    // @Group: RC6_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_6,                    "RC6_", RC_Channel_aux),

    // @Group: RC7_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_7,                    "RC7_", RC_Channel_aux),

    // @Group: RC8_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_8,                    "RC8_", RC_Channel_aux),

#if CONFIG_HAL_BOARD == HAL_BOARD_PX4 || CONFIG_HAL_BOARD == HAL_BOARD_VRBRAIN
    // @Group: RC9_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_9,                    "RC9_", RC_Channel_aux),
#endif

#if CONFIG_HAL_BOARD == HAL_BOARD_APM2 || CONFIG_HAL_BOARD == HAL_BOARD_PX4 || CONFIG_HAL_BOARD == HAL_BOARD_VRBRAIN
    // @Group: RC10_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_10,                    "RC10_", RC_Channel_aux),

    // @Group: RC11_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_11,                    "RC11_", RC_Channel_aux),
#endif

#if CONFIG_HAL_BOARD == HAL_BOARD_PX4 || CONFIG_HAL_BOARD == HAL_BOARD_VRBRAIN
    // @Group: RC12_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_12,                    "RC12_", RC_Channel_aux),

    // @Group: RC13_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_13,                    "RC13_", RC_Channel_aux),

    // @Group: RC14_
    // @Path: ../libraries/RC_Channel/RC_Channel.cpp,../libraries/RC_Channel/RC_Channel_aux.cpp
    GGROUP(rc_14,                    "RC14_", RC_Channel_aux),
#endif

    // @Group: RLL2SRV_
    // @Path: ../libraries/APM_Control/AP_RollController.cpp
	GOBJECT(rollController,         "RLL2SRV_",   AP_RollController),

    // @Group: PTCH2SRV_
    // @Path: ../libraries/APM_Control/AP_PitchController.cpp
	GOBJECT(pitchController,        "PTCH2SRV_",  AP_PitchController),

    // @Group: YAW2SRV_
    // @Path: ../libraries/APM_Control/AP_YawController.cpp
	GOBJECT(yawController,          "YAW2SRV_",   AP_YawController),

    // @Group: STEER2SRV_
    // @Path: ../libraries/APM_Control/AP_SteerController.cpp
	GOBJECT(steerController,        "STEER2SRV_",   AP_SteerController),

	// variables not in the g class which contain EEPROM saved variables

    // @Group: COMPASS_
    // @Path: ../libraries/AP_Compass/Compass.cpp
    GOBJECT(compass,                "COMPASS_",     Compass),

    // @Group: SCHED_
    // @Path: ../libraries/AP_Scheduler/AP_Scheduler.cpp
    GOBJECT(scheduler, "SCHED_", AP_Scheduler),

    // @Group: RCMAP_
    // @Path: ../libraries/AP_RCMapper/AP_RCMapper.cpp
    GOBJECT(rcmap,                "RCMAP_",         RCMapper),

    // @Group: SR0_
    // @Path: GCS_Mavlink.pde
    GOBJECTN(gcs[0], gcs0,        "SR0_",     GCS_MAVLINK),

    // @Group: SR1_
    // @Path: GCS_Mavlink.pde
    GOBJECTN(gcs[1],  gcs1,       "SR1_",     GCS_MAVLINK),

#if MAVLINK_COMM_NUM_BUFFERS > 2
    // @Group: SR2_
    // @Path: GCS_Mavlink.pde
    GOBJECTN(gcs[2],  gcs2,       "SR2_",     GCS_MAVLINK),
#endif

    // @Group: INS_
    // @Path: ../libraries/AP_InertialSensor/AP_InertialSensor.cpp
    GOBJECT(ins,                    "INS_", AP_InertialSensor),

    // @Group: AHRS_
    // @Path: ../libraries/AP_AHRS/AP_AHRS.cpp
    GOBJECT(ahrs,                   "AHRS_",    AP_AHRS),

    // @Group: ARSPD_
    // @Path: ../libraries/AP_Airspeed/AP_Airspeed.cpp
    GOBJECT(airspeed,                               "ARSPD_",   AP_Airspeed),

    // @Group: NAVL1_
    // @Path: ../libraries/AP_L1_Control/AP_L1_Control.cpp
    GOBJECT(L1_controller,         "NAVL1_",   AP_L1_Control),

    // @Group: TECS_
    // @Path: ../libraries/AP_TECS/AP_TECS.cpp
    GOBJECT(TECS_controller,         "TECS_",   AP_TECS),

#if MOUNT == ENABLED
    // @Group: MNT_
    // @Path: ../libraries/AP_Mount/AP_Mount.cpp
    GOBJECT(camera_mount,           "MNT_", AP_Mount),
#endif

#if MOUNT2 == ENABLED
    // @Group: MNT2_
    // @Path: ../libraries/AP_Mount/AP_Mount.cpp
    GOBJECT(camera_mount2,           "MNT2_",       AP_Mount),
#endif

    // @Group: BATT_
    // @Path: ../libraries/AP_BattMonitor/AP_BattMonitor.cpp
    GOBJECT(battery,                "BATT_",       AP_BattMonitor),

    // @Group: BRD_
    // @Path: ../libraries/AP_BoardConfig/AP_BoardConfig.cpp
    GOBJECT(BoardConfig,            "BRD_",       AP_BoardConfig),

#if CONFIG_HAL_BOARD == HAL_BOARD_AVR_SITL
    // @Group: SIM_
    // @Path: ../libraries/SITL/SITL.cpp
    GOBJECT(sitl, "SIM_", SITL),
#endif

#if OBC_FAILSAFE == ENABLED
    // @Group: AFS_
    // @Path: ../libraries/APM_OBC/APM_OBC.cpp
    GOBJECT(obc,  "AFS_", APM_OBC),
#endif

#if AP_AHRS_NAVEKF_AVAILABLE
    // @Group: EKF_
    // @Path: ../libraries/AP_NavEKF/AP_NavEKF.cpp
    GOBJECTN(ahrs.get_NavEKF(), NavEKF, "EKF_", NavEKF),
#endif

#if OPTFLOW == ENABLED
    // @Group: FLOW
    // @Path: ../libraries/AP_OpticalFlow/OpticalFlow.cpp
    GOBJECT(optflow,   "FLOW", OpticalFlow),
#endif

    // @Group: MIS_
    // @Path: ../libraries/AP_Mission/AP_Mission.cpp
    GOBJECT(mission, "MIS_",       AP_Mission),

    // @Group: RALLY_
    // @Path: ../libraries/AP_Rally/AP_Rally.cpp
    GOBJECT(rally,  "RALLY_",       AP_Rally),

    AP_VAREND
};

/*
  This is a conversion table from old parameter values to new
  parameter names. The startup code looks for saved values of the old
  parameters and will copy them across to the new parameters if the
  new parameter does not yet have a saved value. It then saves the new
  value.

  Note that this works even if the old parameter has been removed. It
  relies on the old k_param index not being removed

  The second column below is the index in the var_info[] table for the
  old object. This should be zero for top level parameters.
 */
const AP_Param::ConversionInfo conversion_table[] PROGMEM = {
    { Parameters::k_param_pidServoRoll, 0, AP_PARAM_FLOAT, "RLL2SRV_P" },
    { Parameters::k_param_pidServoRoll, 1, AP_PARAM_FLOAT, "RLL2SRV_I" },
    { Parameters::k_param_pidServoRoll, 2, AP_PARAM_FLOAT, "RLL2SRV_D" },
    { Parameters::k_param_pidServoRoll, 3, AP_PARAM_FLOAT, "RLL2SRV_IMAX" },

    { Parameters::k_param_pidServoPitch, 0, AP_PARAM_FLOAT, "PTCH2SRV_P" },
    { Parameters::k_param_pidServoPitch, 1, AP_PARAM_FLOAT, "PTCH2SRV_I" },
    { Parameters::k_param_pidServoPitch, 2, AP_PARAM_FLOAT, "PTCH2SRV_D" },
    { Parameters::k_param_pidServoPitch, 3, AP_PARAM_FLOAT, "PTCH2SRV_IMAX" },

    { Parameters::k_param_battery_monitoring, 0,      AP_PARAM_INT8,  "BATT_MONITOR" },
    { Parameters::k_param_battery_volt_pin,   0,      AP_PARAM_INT8,  "BATT_VOLT_PIN" },
    { Parameters::k_param_battery_curr_pin,   0,      AP_PARAM_INT8,  "BATT_CURR_PIN" },
    { Parameters::k_param_volt_div_ratio,     0,      AP_PARAM_FLOAT, "BATT_VOLT_MULT" },
    { Parameters::k_param_curr_amp_per_volt,  0,      AP_PARAM_FLOAT, "BATT_AMP_PERVOLT" },
    { Parameters::k_param_curr_amp_offset,    0,      AP_PARAM_FLOAT, "BATT_AMP_OFFSET" },
    { Parameters::k_param_pack_capacity,      0,      AP_PARAM_INT32, "BATT_CAPACITY" },
    { Parameters::k_param_log_bitmask_old,    0,      AP_PARAM_INT16, "LOG_BITMASK" },
    { Parameters::k_param_rally_limit_km_old, 0,      AP_PARAM_FLOAT, "RALLY_LIMIT_KM" },
    { Parameters::k_param_rally_total_old,    0,      AP_PARAM_INT8, "RALLY_TOTAL" },
};

static void load_parameters(void)
{
    if (!AP_Param::check_var_info()) {
        cliSerial->printf_P(PSTR("Bad parameter table\n"));        
        hal.scheduler->panic(PSTR("Bad parameter table"));
    }
    if (!g.format_version.load() ||
        g.format_version != Parameters::k_format_version) {

        // erase all parameters
        cliSerial->printf_P(PSTR("Firmware change: erasing EEPROM...\n"));
        AP_Param::erase_all();

        // save the current format version
        g.format_version.set_and_save(Parameters::k_format_version);
        cliSerial->println_P(PSTR("done."));
    } else {
        uint32_t before = micros();
        // Load all auto-loaded EEPROM variables
        AP_Param::load_all();
        AP_Param::convert_old_parameters(&conversion_table[0], sizeof(conversion_table)/sizeof(conversion_table[0]));
        cliSerial->printf_P(PSTR("load_all took %luus\n"), micros() - before);
    }
}
