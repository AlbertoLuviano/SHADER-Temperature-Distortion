Shader "Custom/HeatColdPP"
{
    Properties
    {
		_MainTex ("Main Texture", 2D) = "white" {}
        _TemperatureRange ("Temperature", Range(-1.0, 1.0)) = 0
		_HotColor ("Hot Tint", Color) = (1.0, 0.4, 0.0, 1.0)
		_ColdColor ("Cold Tint", Color) = (0.0, 0.5, 1.0, 1.0)

		[Header(Control Hotness)]
		[Space(10)]
		_HeatAmplitude ("Heat Amplitude", Range(0, 1)) = 0.5
		_HeatPeriod ("Heat Period", float) = 4
		_HeatPhaseShift ("Heat Phase Shift", float) = 4
		[PowerSlider(0.2)] _HeatUpperLimit ("Heat Upper Limit", Range(0.5, 10)) = 0.5

		[Header(Control Coldness)]
		[Space(10)]
		_ColdNormal ("Cold Normal", 2D) = "white" {}
		_EffectStrength ("FX Strength", Range(0, 1)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex, _ColdNormal;
			float4 _MainTex_SD;
			float _TemperatureRange, 
				_HeatAmplitude, _HeatPeriod, _HeatPhaseShift, _HeatUpperLimit, 
				_EffectStrength;
			half4 _HotColor, _ColdColor;

            fixed4 frag (v2f i) : SV_Target
            {
				float currentHot = clamp(_TemperatureRange, 0, 1);
				float currentCold = -clamp(_TemperatureRange, -1, 0);
				fixed4 HotnessColor = (_HotColor * currentHot);
				fixed4 ColdnessColor = (_ColdColor * currentCold);
				float2 modifiedUVHot = i.uv.xy;
				float2 modifiedUVCold = i.uv.xy;

				modifiedUVHot.x -= (((1 - modifiedUVHot.y) * _HeatAmplitude) * 
					sin(_HeatPeriod * (modifiedUVHot.y - (_Time * _HeatPhaseShift)))) *
					clamp(1 - (modifiedUVHot.y * (10 - _HeatUpperLimit)), 0, 0.5) *
					currentHot;

				_EffectStrength = _EffectStrength * currentCold;
				modifiedUVCold += (UnpackNormal(tex2D(_ColdNormal, i.uv)) * _EffectStrength);

                fixed4 col = tex2D(_MainTex, (modifiedUVHot + modifiedUVCold) * 0.5);
				col.rgb += HotnessColor.rgb * HotnessColor.a;
				col.rgb += ColdnessColor.rgb * ColdnessColor.a;

                return col;
            }
            ENDCG
        }
    }
}
