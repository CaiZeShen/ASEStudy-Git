// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/Cloud"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[HDR]_ShadowColor("ShadowColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_width("width", Range( 0 , 0.5)) = 0.4144565
		_NoiseTex("NoiseTex", 2D) = "white" {}
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
		Cull Front
		ColorMask RGBA
		ZWrite Off
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
				float4 ase_color : COLOR;
			};

			//This is a late directive
			
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform half4 _ShadowColor;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseTex_ST;
			uniform half _width;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				float dotResult7 = dot( worldSpaceLightDir , ase_worldNormal );
				float vertexToFrag23 = (dotResult7*0.5 + 0.5);
				o.ase_texcoord.z = vertexToFrag23;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
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
				float2 uv_NoiseTex = i.ase_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float vertexToFrag23 = i.ase_texcoord.z;
				float temp_output_2_0_g1 = _width;
				float4 lerpResult9 = lerp( ( _MainColor * tex2DNode2 ) , ( _ShadowColor * tex2DNode2 ) , saturate( ( ( tex2D( _NoiseTex, uv_NoiseTex ).r + 1.0 ) - ( saturate( ( ( vertexToFrag23 - temp_output_2_0_g1 ) / ( ( 1.0 - _width ) - temp_output_2_0_g1 ) ) ) * 2.0 ) ) ));
				float4 appendResult13 = (float4(lerpResult9.rgb , ( _MainColor.a * tex2DNode2.a * i.ase_color.a )));
				
				
				finalColor = appendResult13;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
765;263;1466;773;2477.328;421.4686;2.793232;True;False
Node;AmplifyShaderEditor.WorldNormalVector;6;-1757.88,745.0798;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;5;-1810.88,587.0798;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;7;-1491.88,652.0798;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1308.301,937.5781;Half;False;Property;_width;width;3;0;Create;True;0;0;False;0;0.4144565;0.292;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;8;-1314.88,652.0798;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-880.5007,914.5399;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;23;-1029.941,690.9579;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-574.3632,460.4015;Float;True;Property;_NoiseTex;NoiseTex;4;0;Create;True;0;0;False;0;None;f2cb58fb93c99c547970760edfc4fafc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;14;-663.9373,693.157;Float;True;SmoothSetp_Simple;-1;;1;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-193.0802,700.1393;Float;False;2;2;0;FLOAT;0.63;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-209.8821,505.7271;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-213.1924,-330.807;Half;False;Property;_ShadowColor;ShadowColor;1;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.2735849,0.2735849,0.2735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-429.2001,45.00001;Float;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;c1fbde6cba1e81a4d9cf645111ab02a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-2.080141,519.1392;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-373.2,-132;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.9150943,0.9021448,0.9021448,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;92.00002,31.80001;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;146.9077,-287.9071;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;4;-304.044,247.7129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;21;239.9559,399.5949;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;53.86873,201.5657;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;404.1076,-154.3071;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;666.9078,18.89295;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;840.8999,19.3;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Light/Cloud;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;1;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;0;7;0
WireConnection;16;0;15;0
WireConnection;23;0;8;0
WireConnection;14;1;23;0
WireConnection;14;2;15;0
WireConnection;14;3;16;0
WireConnection;20;0;14;0
WireConnection;18;0;17;1
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;11;0;10;0
WireConnection;11;1;2;0
WireConnection;21;0;19;0
WireConnection;12;0;3;4
WireConnection;12;1;2;4
WireConnection;12;2;4;4
WireConnection;9;0;1;0
WireConnection;9;1;11;0
WireConnection;9;2;21;0
WireConnection;13;0;9;0
WireConnection;13;3;12;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=B0D74B1B4A9B376ABC2A98160C411335B1201C13