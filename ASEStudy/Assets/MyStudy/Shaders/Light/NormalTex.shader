// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/NormalTex"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_HightlightColor("HightlightColor", Color) = (1,1,1,1)
		_NormalTex("NormalTex", 2D) = "bump" {}
		_HighlightSize("HighlightSize", Range( 0 , 0.999)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
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
			
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalTex;
			uniform float4 _NormalTex_ST;
			uniform float _HighlightSize;
			uniform half4 _HightlightColor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
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
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv_NormalTex = i.ase_texcoord.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;
				float3 ase_worldTangent = i.ase_texcoord1.xyz;
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 ase_worldBitangent = i.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal5 = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
				float3 worldNormal5 = float3(dot(tanToWorld0,tanNormal5), dot(tanToWorld1,tanNormal5), dot(tanToWorld2,tanNormal5));
				float3 ase_worldPos = i.ase_texcoord4.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float3 normalizeResult4_g2 = normalize( ( ase_worldViewDir + worldSpaceLightDir ) );
				float dotResult13 = dot( worldNormal5 , normalizeResult4_g2 );
				float temp_output_2_0_g3 = _HighlightSize;
				float4 appendResult22 = (float4(( ( _MainColor * tex2DNode2 ) + ( pow( saturate( ( ( dotResult13 - temp_output_2_0_g3 ) / ( 1.0 - temp_output_2_0_g3 ) ) ) , 3.0 ) * _HightlightColor ) ).rgb , ( _MainColor.a * tex2DNode2.a )));
				
				
				finalColor = appendResult22;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
94;404;1466;767;1541.599;39.59427;1.495289;True;False
Node;AmplifyShaderEditor.SamplerNode;27;-1155.215,294.613;Float;True;Property;_NormalTex;NormalTex;3;0;Create;True;0;0;False;0;None;fe34b4b3e872fbb459d4c8f47620746d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;5;-750.7737,303.9253;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;24;-814.2379,452.1986;Float;False;Blinn-Phong Half Vector;-1;;2;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;13;-485.783,304.7557;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-417.142,598.8939;Float;False;Property;_HighlightSize;HighlightSize;4;0;Create;True;0;0;False;0;0;0.999;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;-154.3221,303.1112;Float;True;SmoothSetp_Simple;-1;;3;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0.88;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-207.9,-111.6;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-263.9,65.39999;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;d082f1eba134e394a945e473987a06ca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;18;113.1156,304.1109;Float;True;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;152.0626,548.5471;Half;False;Property;_HightlightColor;HightlightColor;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;438.9629,28.11004;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;454.2406,432.7126;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;438.7327,142.3323;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;670.0982,28.74698;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;949.1876,26.07077;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1175.179,27.17661;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Light/NormalTex;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;5;0;27;0
WireConnection;13;0;5;0
WireConnection;13;1;24;0
WireConnection;17;1;13;0
WireConnection;17;2;28;0
WireConnection;18;0;17;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;26;0;18;0
WireConnection;26;1;25;0
WireConnection;23;0;3;4
WireConnection;23;1;2;4
WireConnection;19;0;1;0
WireConnection;19;1;26;0
WireConnection;22;0;19;0
WireConnection;22;3;23;0
WireConnection;0;0;22;0
ASEEND*/
//CHKSM=18FEED07D9868E036B065DD319694758689AC230