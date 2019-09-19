// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/HalfLambertAndBlinn-Phong"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
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
				float dotResult6 = dot( worldSpaceLightDir , ase_worldNormal );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 normalizeResult15 = normalize( ( worldSpaceLightDir + ase_worldViewDir ) );
				float dotResult13 = dot( ase_worldNormal , normalizeResult15 );
				float temp_output_2_0_g1 = 0.88;
				
				
				finalColor = ( ( _MainColor * tex2D( _MainTex, uv_MainTex ) * (dotResult6*0.5 + 0.5) ) + pow( saturate( ( ( dotResult13 - temp_output_2_0_g1 ) / ( 1.0 - temp_output_2_0_g1 ) ) ) , 5.0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
231;436;1466;741;2173.927;35.63315;2.64176;True;False
Node;AmplifyShaderEditor.CommentaryNode;20;-798.3597,718.5585;Float;False;1491.512;366.6186;Blinn-Phong;6;12;13;18;17;15;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;9;-899.2465,296.1953;Float;False;976.5999;364.1;HalfLambert;4;6;8;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-810.5659,339.0742;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;12;-754.7509,818.0911;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-515.293,801.5692;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;15;-382.2712,800.2524;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;5;-798.9661,497.374;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;13;-166.2756,779.179;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;6;-457.9465,346.1953;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-207.9,-111.6;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-263.9,65.39999;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;84508b93f15f2b64386ec07486afc7a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;8;-172.5774,345.1505;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;176.2413,772.0065;Float;True;SmoothSetp_Simple;-1;;1;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0.88;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;431.2411,773.0065;Float;True;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;435.5989,66.79565;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;670.0982,70.79656;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;842.8834,71.39783;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Light/HalfLambertAndBlinn-Phong;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;15;0;11;0
WireConnection;13;0;5;0
WireConnection;13;1;15;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;8;0;6;0
WireConnection;17;1;13;0
WireConnection;18;0;17;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;8;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;0;0;19;0
ASEEND*/
//CHKSM=43CE05BB1E124E081BEBE4DF34AF2DE8C0FA95E7