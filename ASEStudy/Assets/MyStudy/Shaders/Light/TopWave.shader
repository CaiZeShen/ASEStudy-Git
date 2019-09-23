// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/TopWave"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_WaveTex("WaveTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_WaveColor("WaveColor", Color) = (1,1,1,1)
		_XSpeed("XSpeed", Float) = 0
		_YSpeed("YSpeed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
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
			};

			//This is a late directive
			
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _WaveColor;
			uniform sampler2D _WaveTex;
			uniform sampler2D _NoiseTex;
			uniform half _XSpeed;
			uniform half _YSpeed;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord1.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
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
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 ase_worldPos = i.ase_texcoord1.xyz;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float dotResult7 = dot( worldSpaceLightDir , ase_worldNormal );
				float3 normalizeResult22 = normalize( float3(0,5,0) );
				float dotResult20 = dot( ase_worldNormal , normalizeResult22 );
				float2 appendResult12 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 appendResult30 = (float2(( _XSpeed * _Time.y ) , ( _Time.y * _YSpeed )));
				
				
				finalColor = ( ( _MainColor * tex2D( _MainTex, uv_MainTex ) * (dotResult7*0.5 + 0.5) ) + ( max( dotResult20 , 0.0 ) * _WaveColor * tex2D( _WaveTex, ( ( appendResult12 * float2( 0.8,0.5 ) ) + ( tex2D( _NoiseTex, ( appendResult30 + ( appendResult12 * float2( 0.3,0.3 ) ) ) ).r * 0.2 ) ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
571;199;1466;767;3119.799;-374.0455;2.284885;True;False
Node;AmplifyShaderEditor.CommentaryNode;45;-2460.976,1311.279;Float;False;1725.152;530.4537;扰动;11;32;28;29;33;34;30;38;36;25;27;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2268.927,930.3788;Float;False;538.2421;244.8735;UV;2;12;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-2147.321,993.1597;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-2331.674,1707.677;Half;False;Property;_YSpeed;YSpeed;6;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2334.275,1420.378;Half;False;Property;_XSpeed;XSpeed;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;32;-2410.976,1543.878;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1921.709,1021.196;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-2084.674,1601.077;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2089.874,1445.079;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1672.525,1361.279;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.3,0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-1780.472,1528.277;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;43;-1148.58,561.1703;Float;False;982.1475;384.9634;mask;4;24;20;22;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1397.797,1506.944;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;25;-1229.217,1475.212;Float;True;Property;_NoiseTex;NoiseTex;3;0;Create;True;0;0;False;0;None;f2cb58fb93c99c547970760edfc4fafc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1105.128,1726.733;Half;False;Constant;_Strength;Strength;7;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;19;-1064.432,680.9335;Float;False;Constant;_VisualLightPos;VisualLightPos;4;0;Create;True;0;0;False;0;0,5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;42;-1020.506,185.8189;Float;False;808.1727;351.3418;半labemt漫反射;4;5;9;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-904.8242,1501.189;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;22;-851.1274,686.2245;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;6;-896.5614,380.2473;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;5;-917.2902,235.335;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1519.25,1037.838;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.8,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-626.1609,290.6474;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;20;-633.1888,663.2684;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-685.5747,1217.107;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-354.0106,1194.204;Float;True;Property;_WaveTex;WaveTex;2;0;Create;True;0;0;False;0;None;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-382.5625,-217.0532;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-438.5625,-40.05323;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;e70a4cc9a27a530468623a76c6c025fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;24;-380.7274,662.2252;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-303.0128,1008.264;Float;False;Property;_WaveColor;WaveColor;4;0;Create;True;0;0;False;0;1,1,1,1;0.4764151,1,0.98223,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;9;-424.561,292.2471;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;179.8585,570.3198;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;467.9879,63.4046;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;683.8002,63;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Light/TopWave;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;12;0;15;1
WireConnection;12;1;15;3
WireConnection;34;0;32;2
WireConnection;34;1;29;0
WireConnection;33;0;28;0
WireConnection;33;1;32;2
WireConnection;38;0;12;0
WireConnection;30;0;33;0
WireConnection;30;1;34;0
WireConnection;36;0;30;0
WireConnection;36;1;38;0
WireConnection;25;1;36;0
WireConnection;27;0;25;1
WireConnection;27;1;40;0
WireConnection;22;0;19;0
WireConnection;37;0;12;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;20;0;6;0
WireConnection;20;1;22;0
WireConnection;26;0;37;0
WireConnection;26;1;27;0
WireConnection;10;1;26;0
WireConnection;24;0;20;0
WireConnection;9;0;7;0
WireConnection;16;0;24;0
WireConnection;16;1;17;0
WireConnection;16;2;10;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;9;0
WireConnection;13;0;1;0
WireConnection;13;1;16;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=922002AB22A31CE575CA5514E01CC3C75A6D0877