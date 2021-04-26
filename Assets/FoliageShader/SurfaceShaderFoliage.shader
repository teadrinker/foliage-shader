Shader "Custom/SurfaceShaderFoliage"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        //[HDR]_ColorLighted ("ColorLighted", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Lambert90deg ("Lambert90deg", Range(0,1)) = 0.6
        _Lambert180deg ("Lambert180deg", Range(0,1)) = 0.8
        _AmbientAmount("AmbientAmount", Range(0,1)) = 0.5
        _Ambient0deg ("Ambient0deg", Range(0,1)) = 0.0
        _Ambient90deg ("Ambient90deg", Range(0,1)) = 0.5
        _Ambient180deg ("Ambient180deg", Range(0,1)) = 1.0
        _OffsetAmbient("OffsetAmbient", Range(-1,1)) = -0.1
        //_Glossiness ("Smoothness", Range(0,1)) = 0.5
        //_Metallic ("Metallic", Range(0,1)) = 0.0
        _Cutoff("Transparency (Light transmission)", Range(0.01,1)) = 0.5
        _AlphaOffset("Alpha offset", Range(-1,1)) = 0.1
    }
    SubShader
    {
        Tags {
            "RenderType" = "TransparentCutout"
            "Queue" = "AlphaTest"
            "IgnoreProjector" = "True"
        }
        LOD 200
        AlphaToMask On

        CGPROGRAM
                #pragma surface surf MyFoliage alphatest:_Cutoff

                #define SHIFT_MUL 8.0

                float4 _Color;
                float4 _ColorLighted;
                float _Lambert90deg;
                float _Lambert180deg;
                float _OffsetAmbient;
                float _AmbientAmount;
                float _Ambient0deg;
                float _Ambient90deg;
                float _Ambient180deg;
                float _AlphaOffset;
                //float _Metallic;
                float _Glossiness;
                //float _Cutoff;
                sampler2D _MainTex;

                half4 LightingMyFoliage(SurfaceOutput s, half3 lightDir, half atten) {

                    // info at https://github.com/teadrinker/foliage-shader
                    // Martin Eklund 2021

                    half NdotL = dot (s.Normal, lightDir);
                    NdotL = clamp(NdotL, -1.0, 1.0); // needed to avoid salt artifacts 
                    half diff = NdotL >= 0 ? lerp(_Lambert90deg,           1., NdotL) : lerp(_Lambert90deg, _Lambert180deg, -NdotL);
                    half amb  = NdotL >= 0 ? lerp(_Ambient90deg, _Ambient0deg, NdotL) : lerp(_Ambient90deg, _Ambient180deg, -NdotL);
                    half4 c;
                    c.rgb = SHIFT_MUL * s.Albedo * _LightColor0.rgb * (diff * max(0, _OffsetAmbient + atten + _AmbientAmount * amb));
                    c.a = s.Alpha;
                    return c;
                }

                struct Input {
                    float2 uv_MainTex;
                };
    
                void surf (Input IN, inout SurfaceOutput o) {
                    float4 c = tex2D(_MainTex, IN.uv_MainTex);
                    o.Albedo = c.rgb * _Color.rgb * (1.0 / SHIFT_MUL); // divide by SHIFT_MUL to get a darker baseline, otherwise the range of _OffsetAmbient feels too limited
                    o.Alpha = c.a * _Color.a + _AlphaOffset;
                }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/Diffuse"
}
