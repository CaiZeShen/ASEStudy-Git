// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/Cartoon"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_OutlineColor("OutlineColor", Color) = (1,1,1,1)
		_OutlineWidth("OutlineWidth", Float) = 0
		_RampTex("RampTex", 2D) = "white" {}
		_Min("Min", Range( 0 , 1)) = 0
		_Max("Max", Range( 0 , 1)) = 0
		_RimColor("RimColor", Color) = (1,1,1,1)
		_HightLightColor("HightLightColor", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input
		{
			half filler;
		};
		uniform half _OutlineWidth;
		uniform half4 _OutlineColor;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _OutlineWidth;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			half2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform half4 _MainColor;
		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform sampler2D _RampTex;
		uniform half _Min;
		uniform half _Max;
		uniform half4 _RimColor;
		uniform half4 _HightLightColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half3 ase_worldNormal = i.worldNormal;
			float dotResult11 = dot( ase_worldlightDir , ase_worldNormal );
			half LoN14 = (dotResult11*0.5 + 0.5);
			half2 temp_cast_0 = (LoN14).xx;
			float dotResult18 = dot( ase_worldNormal , i.viewDir );
			half VoN22 = ( 1.0 - max( dotResult18 , 0.0 ) );
			float temp_output_2_0_g1 = _Min;
			float3 normalizeResult24 = normalize( ( ase_worldlightDir + i.viewDir ) );
			float dotResult26 = dot( ase_worldNormal , normalizeResult24 );
			half HoN28 = max( dotResult26 , 0.0 );
			c.rgb = ( ( _MainColor * tex2D( _MainTex, uv_MainTex ) * tex2D( _RampTex, temp_cast_0 ) ) + ( LoN14 * saturate( ( ( VoN22 - temp_output_2_0_g1 ) / ( _Max - temp_output_2_0_g1 ) ) ) * _RimColor ) + ( HoN28 * _HightLightColor ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
203;326;1466;742;3391.761;804.8761;4.032963;True;False
Node;AmplifyShaderEditor.WorldNormalVector;9;-2533.574,549.8192;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-2576.774,370.6191;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;17;-2517.432,751.8072;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2237.931,936.7071;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;18;-2246.532,734.6072;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;24;-2077.398,938.1403;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;20;-2090.299,734.6072;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;11;-2221.574,489.0191;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;26;-1889.631,916.6402;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1763.536,679.4334;Float;False;293;165;Frenel;1;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;12;-2045.574,489.0192;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-1939.798,733.1739;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1831.987,435.4871;Float;False;293;165;漫放射;1;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;27;-1726.231,918.0739;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1781.987,485.4871;Half;False;LoN;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1713.536,729.4334;Half;False;VoN;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1589.441,865.4869;Float;False;293;165;高光;1;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-778.5388,732.5802;Float;False;22;VoN;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-822.7077,497.5133;Float;False;14;LoN;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-834.4388,950.447;Half;False;Property;_Max;Max;6;0;Create;True;0;0;False;0;0;0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-837.3055,857.2803;Half;False;Property;_Min;Min;5;0;Create;True;0;0;False;0;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1539.441,915.4869;Half;False;HoN;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-532.0744,364.4589;Float;True;Property;_RampTex;RampTex;4;0;Create;True;0;0;False;0;None;09a681e332ac7954d8055b5591b6eb26;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-415.1661,987.2322;Half;False;Property;_RimColor;RimColor;7;0;Create;True;0;0;False;0;1,1,1,1;0.2376291,0.4577278,0.5660378,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;36;-390.7314,1240.25;Float;False;28;HoN;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-115.9106,1604.019;Half;False;Property;_HightLightColor;HightLightColor;8;0;Create;True;0;0;False;0;1,1,1,1;0.2169811,0.2082814,0.1954877,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-599.2001,-55.7;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;30;-497.6053,735.4468;Float;True;SmoothSetp_Simple;-1;;1;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-655.2001,121.3;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;e70a4cc9a27a530468623a76c6c025fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;460.3624,605.6608;Half;False;Property;_OutlineWidth;OutlineWidth;3;0;Create;True;0;0;False;0;0;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-204.4,103.3;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1209.97,-761.0876;Float;False;875.4574;523.3092;另外一种阴影做法;5;45;43;40;41;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;206.0966,1246.229;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;449.2222,438.6218;Half;False;Property;_OutlineColor;OutlineColor;2;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-134.972,702.4802;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;37;-140.6678,1339.523;Float;True;SmoothSetp_Simple;-1;;2;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0.9;False;3;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;450.0052,120.3567;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;45;-569.5126,-613.5129;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;43;-881.3967,-490.7784;Float;True;2;0;FLOAT;0.71;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1134.48,-694.7009;Float;False;14;LoN;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1159.97,-472.5707;Float;False;22;VoN;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;42;-892.321,-711.0876;Float;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;6;671.0799,439.3533;Float;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;923.4677,-36.85901;Half;False;True;2;Half;ASEMaterialInspector;0;0;CustomLighting;ShenLin/Light/Cartoon;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;False;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;10;0
WireConnection;23;1;17;0
WireConnection;18;0;9;0
WireConnection;18;1;17;0
WireConnection;24;0;23;0
WireConnection;20;0;18;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;26;0;9;0
WireConnection;26;1;24;0
WireConnection;12;0;11;0
WireConnection;21;0;20;0
WireConnection;27;0;26;0
WireConnection;14;0;12;0
WireConnection;22;0;21;0
WireConnection;28;0;27;0
WireConnection;13;1;15;0
WireConnection;30;1;29;0
WireConnection;30;2;31;0
WireConnection;30;3;32;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;13;0
WireConnection;39;0;36;0
WireConnection;39;1;38;0
WireConnection;33;0;15;0
WireConnection;33;1;30;0
WireConnection;33;2;34;0
WireConnection;37;1;36;0
WireConnection;35;0;1;0
WireConnection;35;1;33;0
WireConnection;35;2;39;0
WireConnection;45;0;42;0
WireConnection;45;1;43;0
WireConnection;43;1;41;0
WireConnection;42;1;40;0
WireConnection;6;0;7;0
WireConnection;6;1;8;0
WireConnection;5;13;35;0
WireConnection;5;11;6;0
ASEEND*/
//CHKSM=0345527974644E6E548DF92551AA7F862EDF4F46