// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Final/Water"
{
	Properties
	{
		_NormalTilling1("NormalTilling1", Float) = 1
		_NormalTilling2("NormalTilling2", Float) = 0.59
		_NormalTex("NormalTex", 2D) = "bump" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		[HDR]_HighlightColor("HighlightColor", Color) = (0,0,0,0)
		_WaterColor("WaterColor", Color) = (0,0,0,0)
		_DepthColor("DepthColor", Color) = (0,0,0,0)
		_NoiseScale("NoiseScale", Float) = 0
	}
	
	SubShader
	{
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		
		
		GrabPass{ }

		Pass
		{
			Name "Unlit"
			
			CGPROGRAM

#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
		//only defining to not throw compilation error over Unity 5.5
		#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
#endif
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
			};

			//This is a late directive
			
			uniform half4 _DepthColor;
			uniform half4 _WaterColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			UNITY_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform half _NoiseScale;
			uniform sampler2D _NormalTex;
			uniform half _NormalTilling2;
			uniform half4 _Speed;
			uniform half _NormalTilling1;
			uniform half4 _FresnelColor;
			uniform half4 _HighlightColor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord = screenPos;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord1.xyz = ase_worldPos;
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue =  float3(0,0,0) ;

				v.vertex.xyz += vertexValue;

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float4 screenPos = i.ase_texcoord;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth53 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD( screenPos )));
				float distanceDepth53 = saturate( abs( ( screenDepth53 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) ) );
				float temp_output_54_0 = ( 1.0 - distanceDepth53 );
				float temp_output_57_0 = ( temp_output_54_0 * temp_output_54_0 * temp_output_54_0 );
				float4 lerpResult51 = lerp( _DepthColor , _WaterColor , temp_output_57_0);
				float3 ase_worldPos = i.ase_texcoord1.xyz;
				float2 appendResult6 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 appendResult23 = (float2(_Speed.x , _Speed.y));
				float2 appendResult26 = (float2(_Speed.z , _Speed.w));
				float3 Normal17 = BlendNormals( UnpackNormal( tex2D( _NormalTex, ( ( appendResult6 / _NormalTilling2 ) + ( _Time.x * appendResult23 ) ) ) ) , UnpackScaleNormal( tex2D( _NormalTex, ( ( appendResult6 / _NormalTilling1 ) + ( _Time.x * appendResult26 ) ) ), 0.7 ) );
				float temp_output_2_0_g3 = 0.02;
				float WaterMask56 = saturate( ( ( distanceDepth53 - temp_output_2_0_g3 ) / ( 0.1 - temp_output_2_0_g3 ) ) );
				float4 screenColor67 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,(( ase_screenPosNorm + float4( ( _NoiseScale * Normal17 * WaterMask56 ) , 0.0 ) )).xy);
				float4 lerpResult68 = lerp( lerpResult51 , screenColor67 , temp_output_57_0);
				float4 WaterColor69 = lerpResult68;
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal28 = Normal17;
				float3 worldNormal28 = float3(dot(tanToWorld0,tanNormal28), dot(tanToWorld1,tanNormal28), dot(tanToWorld2,tanNormal28));
				float3 normalizeResult29 = normalize( worldNormal28 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float dotResult33 = dot( normalizeResult29 , ase_worldViewDir );
				float4 FresnelColor41 = ( _FresnelColor * ( 1.0 - max( dotResult33 , 0.0 ) ) * WaterMask56 );
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float3 normalizeResult4_g4 = normalize( ( ase_worldViewDir + worldSpaceLightDir ) );
				float dotResult34 = dot( normalizeResult29 , normalizeResult4_g4 );
				float temp_output_38_0 = max( dotResult34 , 0.0 );
				float temp_output_2_0_g5 = 0.99;
				float4 HighlightColor48 = ( saturate( ( ( ( temp_output_38_0 * temp_output_38_0 * temp_output_38_0 * temp_output_38_0 * temp_output_38_0 ) - temp_output_2_0_g5 ) / ( 1.0 - temp_output_2_0_g5 ) ) ) * _HighlightColor * WaterMask56 );
				
				
				finalColor = ( WaterColor69 + FresnelColor41 + HighlightColor48 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
-127;261;1466;894;1881.47;-265.7662;1.959283;True;False
Node;AmplifyShaderEditor.CommentaryNode;74;-1157.835,-249.6923;Float;False;1783.931;878.5358;;18;25;5;6;10;26;9;23;20;21;7;22;8;12;11;14;13;16;17;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;25;-1064.433,398.8435;Half;False;Property;_Speed;Speed;3;0;Create;True;0;0;False;0;0,0,0,0;1,-0.17,0,0.25;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-1107.835,-86.63988;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-905.0353,58.96012;Half;False;Property;_NormalTilling1;NormalTilling1;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-894.6351,-51.53983;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-817.4331,495.8435;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-893.3353,143.46;Half;False;Property;_NormalTilling2;NormalTilling2;1;0;Create;True;0;0;False;0;0.59;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;20;-919.4331,242.8435;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-815.4331,405.8435;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-635.9354,-132.1398;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-607.4331,358.8435;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-609.4331,240.8435;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-628.1353,10.86019;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-418.4037,5.958182;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-432.7037,-134.4419;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;14;-196.404,-199.6923;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Instance;13;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-196.1418,20.72832;Float;True;Property;_NormalTex;NormalTex;2;0;Create;True;0;0;False;0;dd2fd2df93418444c8e280f1d34deeb5;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.7;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;16;151.2961,-60.99229;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1205.541,-1323.637;Float;False;1579.424;995.6339;;18;53;55;56;61;63;62;64;59;54;60;50;49;66;57;67;51;68;69;Water;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1227.915,718.1141;Float;False;1919.18;806.1454;;20;27;28;29;35;31;34;38;33;37;40;39;46;43;45;44;47;41;48;78;79;反射;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;53;-1079.767,-593.6699;Float;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;383.0961,-66.69223;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1177.915,984.3453;Float;False;17;Normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;55;-779.5541,-484.0034;Float;False;SmoothSetp_Simple;-1;;3;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0.02;False;3;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;28;-975.4775,989.2858;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-520.4662,-486.7451;Float;False;WaterMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1153.707,-990.8706;Float;False;17;Normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1126.893,-1079.109;Half;False;Property;_NoiseScale;NoiseScale;8;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1155.541,-899.1948;Float;False;56;WaterMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;35;-1032.703,1329.782;Float;False;Blinn-Phong Half Vector;-1;;4;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;29;-723.6817,989.2858;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;59;-1004.277,-1254.44;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;34;-507.652,1159.534;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;31;-959.7402,1156.673;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-918.3301,-1008.06;Float;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;33;-519.0974,992.147;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-786.4081,-593.6703;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-707.4751,-1251.002;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;38;-364.5864,1159.534;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-721.3262,-955.6312;Half;False;Property;_WaterColor;WaterColor;6;0;Create;True;0;0;False;0;0,0,0,0;0.3504361,0.8817644,0.990566,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-177.1698,1165.257;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;-563.2311,-1254.19;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;50;-726.6101,-773.6338;Half;False;Property;_DepthColor;DepthColor;7;0;Create;True;0;0;False;0;0,0,0,0;0.06207725,0.1146788,0.4245283,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;37;-371.7395,992.147;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-337.0142,1441.404;Float;False;56;WaterMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-534.1752,-607.3785;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;45;9.840204,1168.468;Float;False;SmoothSetp_Simple;-1;;5;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0.99;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;29.80364,1342.735;Half;False;Property;_HighlightColor;HighlightColor;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,0.8349056,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;67;-319.474,-1254.247;Float;False;Global;_GrabScreen0;Grab Screen 0;9;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;39;-234.3962,992.1472;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;79;-25.9542,1338.789;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-263.3104,768.1141;Half;False;Property;_FresnelColor;FresnelColor;4;0;Create;True;0;0;False;0;0,0,0,0;0.05553579,0.2071364,0.3018868,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;51;-285.1184,-773.6339;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;283.9947,1164.795;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-15.54749,971.4349;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;68;-49.76553,-1268.105;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;446.2644,1161.973;Float;False;HighlightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;130.8828,-1273.637;Float;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;165.8062,964.9424;Float;False;FresnelColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;1123.27,-140.0293;Float;False;41;FresnelColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;1118.934,-43.21605;Float;False;48;HighlightColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;1126.368,-229.1257;Float;False;69;WaterColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;1418.332,-159.5733;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1598.915,-158.0609;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Final/Water;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;1
WireConnection;6;1;5;3
WireConnection;26;0;25;3
WireConnection;26;1;25;4
WireConnection;23;0;25;1
WireConnection;23;1;25;2
WireConnection;7;0;6;0
WireConnection;7;1;10;0
WireConnection;22;0;20;1
WireConnection;22;1;26;0
WireConnection;21;0;20;1
WireConnection;21;1;23;0
WireConnection;8;0;6;0
WireConnection;8;1;9;0
WireConnection;12;0;8;0
WireConnection;12;1;22;0
WireConnection;11;0;7;0
WireConnection;11;1;21;0
WireConnection;14;1;11;0
WireConnection;13;1;12;0
WireConnection;16;0;14;0
WireConnection;16;1;13;0
WireConnection;17;0;16;0
WireConnection;55;1;53;0
WireConnection;28;0;27;0
WireConnection;56;0;55;0
WireConnection;29;0;28;0
WireConnection;34;0;29;0
WireConnection;34;1;35;0
WireConnection;64;0;61;0
WireConnection;64;1;62;0
WireConnection;64;2;63;0
WireConnection;33;0;29;0
WireConnection;33;1;31;0
WireConnection;54;0;53;0
WireConnection;60;0;59;0
WireConnection;60;1;64;0
WireConnection;38;0;34;0
WireConnection;40;0;38;0
WireConnection;40;1;38;0
WireConnection;40;2;38;0
WireConnection;40;3;38;0
WireConnection;40;4;38;0
WireConnection;66;0;60;0
WireConnection;37;0;33;0
WireConnection;57;0;54;0
WireConnection;57;1;54;0
WireConnection;57;2;54;0
WireConnection;45;1;40;0
WireConnection;67;0;66;0
WireConnection;39;0;37;0
WireConnection;79;0;78;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;51;2;57;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;47;2;79;0
WireConnection;44;0;43;0
WireConnection;44;1;39;0
WireConnection;44;2;78;0
WireConnection;68;0;51;0
WireConnection;68;1;67;0
WireConnection;68;2;57;0
WireConnection;48;0;47;0
WireConnection;69;0;68;0
WireConnection;41;0;44;0
WireConnection;72;0;18;0
WireConnection;72;1;42;0
WireConnection;72;2;58;0
WireConnection;0;0;72;0
ASEEND*/
//CHKSM=9F7BE8045B0169E6B77B2CDBC11425E23F16CBC4