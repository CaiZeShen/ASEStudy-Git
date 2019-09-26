// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "D/DaoguangShader_AlphaBlend"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_EmissionIntensity("EmissionIntensity", Range( 0 , 20)) = 1
		_AlphaIntensity("AlphaIntensity", Range( 0 , 2)) = 1
		_Tessellation("Tessellation", Range( 0 , 10)) = 5
		_MainTex("MainTex", 2D) = "white" {}
		_Main_USpeed("Main_USpeed", Range( -1 , 1)) = 0
		_Main_VSpeed("Main_VSpeed", Range( -1 , 1)) = 0
		_MainTexRGBPower("MainTexRGBPower", Range( 0 , 5)) = 2
		[KeywordEnum(Animation,UV2_Z)] _SmoothstepMode("SmoothstepMode", Float) = 0
		_AlphaSmoothstep("AlphaSmoothstep", Range( 0 , 1)) = 0
		_Mask("Mask", 2D) = "white" {}
		[KeywordEnum(Off,UV2_XY)] _Mask_UV("Mask_UV", Float) = 0
		[KeywordEnum(Off,On)] _AlphaNoiseTex_Switch("AlphaNoiseTex_Switch", Float) = 0
		_AlphaNoiseTex("AlphaNoiseTex", 2D) = "white" {}
		_AlphaNoiseTex_U("AlphaNoiseTex_U", Range( -1 , 1)) = 0
		_AlphaNoiseTex_V("AlphaNoiseTex_V", Range( -1 , 1)) = 0
		[KeywordEnum(Animation,UV2_W)] _VertexOffsetMode("VertexOffsetMode", Float) = 0
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 2)) = 0
		[KeywordEnum(Off,Left,Right,Down,Top,X,Y,XY)] _UVMask("UVMask", Float) = 0
		_UVMaskIntensity("UVMaskIntensity", Float) = 1
		_UVMaskBlur("UVMaskBlur", Range( 0 , 20)) = 1
		[KeywordEnum(RGB,Alpha)] _AlphaMode("AlphaMode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature _SMOOTHSTEPMODE_ANIMATION _SMOOTHSTEPMODE_UV2_Z
		#pragma shader_feature _ALPHANOISETEX_SWITCH_OFF _ALPHANOISETEX_SWITCH_ON
		#pragma shader_feature _ALPHAMODE_RGB _ALPHAMODE_ALPHA
		#pragma shader_feature _VERTEXOFFSETMODE_ANIMATION _VERTEXOFFSETMODE_UV2_W
		#pragma shader_feature _UVMASK_OFF _UVMASK_LEFT _UVMASK_RIGHT _UVMASK_DOWN _UVMASK_TOP _UVMASK_X _UVMASK_Y _UVMASK_XY
		#pragma shader_feature _MASK_UV_OFF _MASK_UV_UV2_XY
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 uv2_tex4coord2;
		};

		uniform float _AlphaSmoothstep;
		uniform sampler2D _MainTex;
		uniform float _Main_USpeed;
		uniform float _Main_VSpeed;
		uniform float4 _MainTex_ST;
		uniform sampler2D _AlphaNoiseTex;
		uniform float _AlphaNoiseTex_U;
		uniform float _AlphaNoiseTex_V;
		uniform float4 _AlphaNoiseTex_ST;
		uniform float _VertexOffsetIntensity;
		uniform float _EmissionIntensity;
		uniform float _MainTexRGBPower;
		uniform float4 _Color;
		uniform float _AlphaIntensity;
		uniform float _UVMaskIntensity;
		uniform float _UVMaskBlur;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _Tessellation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_2 = (_Tessellation).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			#if defined(_SMOOTHSTEPMODE_ANIMATION)
				float staticSwitch34 = _AlphaSmoothstep;
			#elif defined(_SMOOTHSTEPMODE_UV2_Z)
				float staticSwitch34 = v.texcoord1.z;
			#else
				float staticSwitch34 = _AlphaSmoothstep;
			#endif
			float2 appendResult26 = (float2(_Main_USpeed , _Main_VSpeed));
			float2 uv0_MainTex = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner22 = ( 1.0 * _Time.y * appendResult26 + uv0_MainTex);
			float4 tex2DNode1 = tex2Dlod( _MainTex, float4( panner22, 0, 0.0) );
			float grayscale28 = (tex2DNode1.rgb.r + tex2DNode1.rgb.g + tex2DNode1.rgb.b) / 3;
			#if defined(_ALPHAMODE_RGB)
				float staticSwitch107 = grayscale28;
			#elif defined(_ALPHAMODE_ALPHA)
				float staticSwitch107 = tex2DNode1.a;
			#else
				float staticSwitch107 = grayscale28;
			#endif
			float MainTexRGB85 = staticSwitch107;
			float2 appendResult71 = (float2(_AlphaNoiseTex_U , _AlphaNoiseTex_V));
			float2 uv0_AlphaNoiseTex = v.texcoord.xy * _AlphaNoiseTex_ST.xy + _AlphaNoiseTex_ST.zw;
			float2 panner67 = ( 1.0 * _Time.y * appendResult71 + uv0_AlphaNoiseTex);
			float grayscale64 = (tex2Dlod( _AlphaNoiseTex, float4( panner67, 0, 0.0) ).rgb.r + tex2Dlod( _AlphaNoiseTex, float4( panner67, 0, 0.0) ).rgb.g + tex2Dlod( _AlphaNoiseTex, float4( panner67, 0, 0.0) ).rgb.b) / 3;
			float AlphaNoiseRGB83 = grayscale64;
			#if defined(_ALPHANOISETEX_SWITCH_OFF)
				float staticSwitch72 = MainTexRGB85;
			#elif defined(_ALPHANOISETEX_SWITCH_ON)
				float staticSwitch72 = ( MainTexRGB85 + AlphaNoiseRGB83 );
			#else
				float staticSwitch72 = MainTexRGB85;
			#endif
			float clampResult78 = clamp( staticSwitch72 , 0.0 , 1.0 );
			float smoothstepResult13 = smoothstep( staticSwitch34 , 1.0 , clampResult78);
			#if defined(_VERTEXOFFSETMODE_ANIMATION)
				float staticSwitch76 = _VertexOffsetIntensity;
			#elif defined(_VERTEXOFFSETMODE_UV2_W)
				float staticSwitch76 = v.texcoord1.w;
			#else
				float staticSwitch76 = _VertexOffsetIntensity;
			#endif
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( smoothstepResult13 * staticSwitch76 * ase_vertexNormal );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult26 = (float2(_Main_USpeed , _Main_VSpeed));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner22 = ( 1.0 * _Time.y * appendResult26 + uv0_MainTex);
			float4 tex2DNode1 = tex2D( _MainTex, panner22 );
			float grayscale28 = (tex2DNode1.rgb.r + tex2DNode1.rgb.g + tex2DNode1.rgb.b) / 3;
			#if defined(_ALPHAMODE_RGB)
				float staticSwitch107 = grayscale28;
			#elif defined(_ALPHAMODE_ALPHA)
				float staticSwitch107 = tex2DNode1.a;
			#else
				float staticSwitch107 = grayscale28;
			#endif
			float MainTexRGB85 = staticSwitch107;
			o.Emission = ( ( _EmissionIntensity * pow( MainTexRGB85 , _MainTexRGBPower ) * _Color ) * i.vertexColor ).rgb;
			#if defined(_SMOOTHSTEPMODE_ANIMATION)
				float staticSwitch34 = _AlphaSmoothstep;
			#elif defined(_SMOOTHSTEPMODE_UV2_Z)
				float staticSwitch34 = i.uv2_tex4coord2.z;
			#else
				float staticSwitch34 = _AlphaSmoothstep;
			#endif
			float2 appendResult71 = (float2(_AlphaNoiseTex_U , _AlphaNoiseTex_V));
			float2 uv0_AlphaNoiseTex = i.uv_texcoord * _AlphaNoiseTex_ST.xy + _AlphaNoiseTex_ST.zw;
			float2 panner67 = ( 1.0 * _Time.y * appendResult71 + uv0_AlphaNoiseTex);
			float grayscale64 = (tex2D( _AlphaNoiseTex, panner67 ).rgb.r + tex2D( _AlphaNoiseTex, panner67 ).rgb.g + tex2D( _AlphaNoiseTex, panner67 ).rgb.b) / 3;
			float AlphaNoiseRGB83 = grayscale64;
			#if defined(_ALPHANOISETEX_SWITCH_OFF)
				float staticSwitch72 = MainTexRGB85;
			#elif defined(_ALPHANOISETEX_SWITCH_ON)
				float staticSwitch72 = ( MainTexRGB85 + AlphaNoiseRGB83 );
			#else
				float staticSwitch72 = MainTexRGB85;
			#endif
			float clampResult78 = clamp( staticSwitch72 , 0.0 , 1.0 );
			float smoothstepResult13 = smoothstep( staticSwitch34 , 1.0 , clampResult78);
			float temp_output_92_0 = ( 1.0 - i.uv_texcoord.x );
			float temp_output_98_0 = ( 1.0 - i.uv_texcoord.y );
			float temp_output_99_0 = ( i.uv_texcoord.y * temp_output_98_0 );
			float temp_output_91_0 = ( i.uv_texcoord.x * temp_output_92_0 );
			#if defined(_UVMASK_OFF)
				float staticSwitch100 = 1.0;
			#elif defined(_UVMASK_LEFT)
				float staticSwitch100 = temp_output_92_0;
			#elif defined(_UVMASK_RIGHT)
				float staticSwitch100 = i.uv_texcoord.x;
			#elif defined(_UVMASK_DOWN)
				float staticSwitch100 = temp_output_98_0;
			#elif defined(_UVMASK_TOP)
				float staticSwitch100 = i.uv_texcoord.y;
			#elif defined(_UVMASK_X)
				float staticSwitch100 = temp_output_99_0;
			#elif defined(_UVMASK_Y)
				float staticSwitch100 = temp_output_91_0;
			#elif defined(_UVMASK_XY)
				float staticSwitch100 = ( temp_output_91_0 * temp_output_99_0 );
			#else
				float staticSwitch100 = 1.0;
			#endif
			float clampResult95 = clamp( pow( ( staticSwitch100 * _UVMaskIntensity ) , _UVMaskBlur ) , 0.0 , 1.0 );
			float UVMask103 = clampResult95;
			float2 uv0_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float2 appendResult40 = (float2(i.uv2_tex4coord2.x , i.uv2_tex4coord2.y));
			#if defined(_MASK_UV_OFF)
				float2 staticSwitch44 = uv0_Mask;
			#elif defined(_MASK_UV_UV2_XY)
				float2 staticSwitch44 = ( uv0_Mask + appendResult40 );
			#else
				float2 staticSwitch44 = uv0_Mask;
			#endif
			float grayscale41 = (tex2D( _Mask, staticSwitch44 ).rgb.r + tex2D( _Mask, staticSwitch44 ).rgb.g + tex2D( _Mask, staticSwitch44 ).rgb.b) / 3;
			float MaskTexRGB42 = grayscale41;
			o.Alpha = ( i.vertexColor.a * _Color.a * ( smoothstepResult13 * _AlphaIntensity * UVMask103 ) * MaskTexRGB42 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
1920;0;1920;1019;4948.446;1225.998;3.409519;True;False
Node;AmplifyShaderEditor.CommentaryNode;79;-3573.177,-418.0347;Float;False;2037.083;423.4651;Comment;10;85;28;1;22;26;6;25;24;21;107;//贴图颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;80;-3582.057,90.99711;Float;False;2031.427;448.8369;Comment;9;83;64;65;62;67;68;71;70;69;//Alpha通道噪波纹理;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;21;-3504.099,-368.0347;Float;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;False;0;61c0b9c0523734e0e91bc6043c72a490;95779980e04043a4aa34e1238fb82203;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3523.177,-183.8771;Float;False;Property;_Main_USpeed;Main_USpeed;7;0;Create;True;0;0;False;0;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3518.928,-111.5696;Float;False;Property;_Main_VSpeed;Main_VSpeed;8;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-3578.766,1122.317;Float;False;2996.507;464.1193;Comment;14;90;92;98;99;91;102;101;94;100;97;93;96;95;103;//程序UV遮罩;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-3532.057,140.9971;Float;True;Property;_AlphaNoiseTex;AlphaNoiseTex;15;0;Create;True;0;0;False;0;cd460ee4ac5c1e746b7a734cc7cc64dd;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-3278.885,344.5264;Float;False;Property;_AlphaNoiseTex_U;AlphaNoiseTex_U;16;0;Create;True;0;0;False;0;0;-0.122;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-3233.982,-301.9974;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-3274.636,416.8339;Float;False;Property;_AlphaNoiseTex_V;AlphaNoiseTex_V;17;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-3144.305,-181.201;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-2913.042,-299.9483;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-2900.011,347.2024;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;90;-3528.766,1246.96;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-3027.549,233.5782;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2659.208,-364.2644;Float;True;Property;_Line01;Line01;1;0;Create;True;0;0;False;0;95779980e04043a4aa34e1238fb82203;95779980e04043a4aa34e1238fb82203;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;67;-2638.092,247.796;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;98;-3169.047,1476.436;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-3224.47,1225.722;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-3582.891,596.8365;Float;False;2048.593;451.9977;Comment;9;77;42;41;36;44;39;38;40;37;//遮罩走一次UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;62;-2407.02,148.7151;Float;True;Property;_TextureSample1;Texture Sample 1;16;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;28;-2295.533,-364.7049;Float;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2968.766,1175.469;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-2968.047,1397.708;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;64;-2037.118,150.6259;Float;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;77;-3520.519,838.0655;Float;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;37;-3532.891,646.8365;Float;True;Property;_Mask;Mask;12;0;Create;True;0;0;False;0;5228a04ef529d2641937cab585cc1a02;5228a04ef529d2641937cab585cc1a02;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2339.267,1172.317;Float;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2790.229,1289.558;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;107;-2021.463,-295.4373;Float;False;Property;_AlphaMode;AlphaMode;23;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;2;RGB;Alpha;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2001.788,1430.053;Float;False;Property;_UVMaskIntensity;UVMaskIntensity;21;0;Create;True;0;0;False;0;1;7.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;100;-1995.319,1197.781;Float;False;Property;_UVMask;UVMask;20;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;8;Off;Left;Right;Down;Top;X;Y;XY;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-3137.083,849.4552;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-1820.208,152.3823;Float;True;AlphaNoiseRGB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3209.695,721.6348;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-1767.027,-295.1376;Float;True;MainTexRGB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-1395.453,-41.96638;Float;True;85;MainTexRGB;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1689.914,1203.383;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2916.416,812.0493;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-1395.797,149.6583;Float;True;83;AlphaNoiseRGB;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1735.731,1332.689;Float;False;Property;_UVMaskBlur;UVMaskBlur;22;0;Create;True;0;0;False;0;1;1.07;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;96;-1447.732,1202.359;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;44;-2739.584,729.1655;Float;False;Property;_Mask_UV;Mask_UV;13;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;Off;UV2_XY;Create;False;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1039.822,80.31801;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;72;-844.4963,18.5073;Float;True;Property;_AlphaNoiseTex_Switch;AlphaNoiseTex_Switch;14;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;Off;On;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1085.757,270.493;Float;False;Property;_AlphaSmoothstep;AlphaSmoothstep;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;88;-1415.842,372.5271;Float;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-2430.164,649.5587;Float;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;95;-1151.749,1200.366;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;34;-664.0101,272.4081;Float;False;Property;_SmoothstepMode;SmoothstepMode;10;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;Animation;UV2_Z;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-258.2451,-329.8546;Float;True;85;MainTexRGB;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1084.265,435.7751;Float;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;19;0;Create;True;0;0;False;0;0;0.545;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;78;-506.7341,21.42529;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;41;-2046.864,649.1739;Float;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-286.8119,-119.4839;Float;False;Property;_MainTexRGBPower;MainTexRGBPower;9;0;Create;True;0;0;False;0;2;3.59;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-881.2574,1196.964;Float;True;UVMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1779,648.6699;Float;True;MaskTexRGB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;438.0944,174.0654;Float;True;103;UVMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;9;-350.875,512.162;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;2;111.3465,-266.3588;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;76;-641.9587,441.279;Float;False;Property;_VertexOffsetMode;VertexOffsetMode;18;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;Animation;UV2_W;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;115.1924,110.2306;Float;False;Property;_AlphaIntensity;AlphaIntensity;3;0;Create;True;0;0;False;0;1;1.33;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;338.7114,-144.0043;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;1,1,1,1;1,0.09905658,0.09905658,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;274.858,-341.6415;Float;False;Property;_EmissionIntensity;EmissionIntensity;2;0;Create;True;0;0;False;0;1;1.07;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-260.403,22.46029;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;281.9287,430.0549;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;750.4766,135.1648;Float;True;42;MaskTexRGB;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;639.6392,-290.0147;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;55;888.238,-190.7232;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;767.7913,17.2619;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;1174.317,523.5439;Float;False;Property;_Tessellation;Tessellation;4;0;Create;True;0;0;False;0;5;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1225.092,-74.92554;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1242.248,-286.6313;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;108;1140.29,384.2483;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1651.173,-336.3643;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;D/DaoguangShader_AlphaBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Opaque;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;56;2;5;False;-1;10;False;56;0;False;-1;0;False;56;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;106;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;2;21;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;22;0;6;0
WireConnection;22;2;26;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;68;2;65;0
WireConnection;1;0;21;0
WireConnection;1;1;22;0
WireConnection;67;0;68;0
WireConnection;67;2;71;0
WireConnection;98;0;90;2
WireConnection;92;0;90;1
WireConnection;62;0;65;0
WireConnection;62;1;67;0
WireConnection;28;0;1;0
WireConnection;91;0;90;1
WireConnection;91;1;92;0
WireConnection;99;0;90;2
WireConnection;99;1;98;0
WireConnection;64;0;62;0
WireConnection;102;0;91;0
WireConnection;102;1;99;0
WireConnection;107;1;28;0
WireConnection;107;0;1;4
WireConnection;100;1;101;0
WireConnection;100;0;92;0
WireConnection;100;2;90;1
WireConnection;100;3;98;0
WireConnection;100;4;90;2
WireConnection;100;5;99;0
WireConnection;100;6;91;0
WireConnection;100;7;102;0
WireConnection;40;0;77;1
WireConnection;40;1;77;2
WireConnection;83;0;64;0
WireConnection;38;2;37;0
WireConnection;85;0;107;0
WireConnection;93;0;100;0
WireConnection;93;1;94;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;96;0;93;0
WireConnection;96;1;97;0
WireConnection;44;1;38;0
WireConnection;44;0;39;0
WireConnection;61;0;87;0
WireConnection;61;1;84;0
WireConnection;72;1;87;0
WireConnection;72;0;61;0
WireConnection;36;0;37;0
WireConnection;36;1;44;0
WireConnection;95;0;96;0
WireConnection;34;1;14;0
WireConnection;34;0;88;3
WireConnection;78;0;72;0
WireConnection;41;0;36;0
WireConnection;103;0;95;0
WireConnection;42;0;41;0
WireConnection;2;0;86;0
WireConnection;2;1;32;0
WireConnection;76;1;10;0
WireConnection;76;0;88;4
WireConnection;13;0;78;0
WireConnection;13;1;34;0
WireConnection;8;0;13;0
WireConnection;8;1;76;0
WireConnection;8;2;9;0
WireConnection;3;0;52;0
WireConnection;3;1;2;0
WireConnection;3;2;57;0
WireConnection;73;0;13;0
WireConnection;73;1;74;0
WireConnection;73;2;104;0
WireConnection;54;0;55;4
WireConnection;54;1;57;4
WireConnection;54;2;73;0
WireConnection;54;3;43;0
WireConnection;53;0;3;0
WireConnection;53;1;55;0
WireConnection;108;0;8;0
WireConnection;0;2;53;0
WireConnection;0;9;54;0
WireConnection;0;11;108;0
WireConnection;0;14;11;0
ASEEND*/
//CHKSM=C3C5C1F8D66B4CF3F95B9AACCEC4E7C4AFD8874F