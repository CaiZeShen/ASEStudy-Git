// Upgrade NOTE: upgraded instancing buffer 'ShenLinDissolveRamp' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Dissolve/Ramp"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_Dissovle("Dissovle", Range( 0 , 1)) = 0
		_Hardness("Hardness", Range( 0.001 , 1)) = 0
		[HDR]_RampColor("RampColor", Color) = (1,1,1,1)
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
			#pragma multi_compile_instancing


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			};

			uniform sampler2D _RampTex;
			uniform sampler2D _NoiseTex;
			uniform half _Dissovle;
			uniform half _Hardness;
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			UNITY_INSTANCING_BUFFER_START(ShenLinDissolveRamp)
				UNITY_DEFINE_INSTANCED_PROP(float4, _NoiseTex_ST)
#define _NoiseTex_ST_arr ShenLinDissolveRamp
				UNITY_DEFINE_INSTANCED_PROP(half4, _RampColor)
#define _RampColor_arr ShenLinDissolveRamp
				UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr ShenLinDissolveRamp
			UNITY_INSTANCING_BUFFER_END(ShenLinDissolveRamp)
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
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
				float4 _NoiseTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseTex_ST_arr, _NoiseTex_ST);
				float2 uv_NoiseTex = i.ase_texcoord.xy * _NoiseTex_ST_Instance.xy + _NoiseTex_ST_Instance.zw;
				float temp_output_2_0_g1 = ( 1.0 - _Hardness );
				float temp_output_15_0 = saturate( ( ( ( ( tex2D( _NoiseTex, uv_NoiseTex ).r + 1.0 ) - ( _Dissovle * 2.0 ) ) - temp_output_2_0_g1 ) / ( 1.0 - temp_output_2_0_g1 ) ) );
				float2 appendResult11 = (float2(temp_output_15_0 , 0.0));
				float4 tex2DNode6 = tex2D( _RampTex, appendResult11 );
				half4 _RampColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_RampColor_arr, _RampColor);
				float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float4 lerpResult14 = lerp( ( tex2DNode6 * _RampColor_Instance ) , ( _MainColor * tex2DNode2 * i.ase_color ) , tex2DNode6.a);
				float4 appendResult20 = (float4(lerpResult14.rgb , ( _MainColor.a * tex2DNode2.a * i.ase_color.a * temp_output_15_0 )));
				
				
				finalColor = appendResult20;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;1;1906;1010;1164.925;434.5342;1.607675;True;False
Node;AmplifyShaderEditor.RangedFloatNode;9;-1510.963,726.475;Half;False;Property;_Dissovle;Dissovle;4;0;Create;True;0;0;False;0;0;0.2285034;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1476.218,534.9405;Float;True;Property;_NoiseTex;NoiseTex;2;0;Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1117.372,563.4203;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1176.966,733.475;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1213.016,900.4067;Half;False;Property;_Hardness;Hardness;5;0;Create;True;0;0;False;0;0;0.385;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-843.4244,797.8973;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-969.3729,563.4203;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;15;-677.0984,565.0714;Float;True;SmoothSetp_Simple;-1;;1;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-375.8638,564.547;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;23;-64.76957,754.0329;Half;False;InstancedProperty;_RampColor;RampColor;6;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;18;-158.5752,473.2287;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;908c9641b9abfd846bf19bccd670267d;80ab37a9e4f49c842903bb43bdd7bcd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;4;54.95589,287.6129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-150.1815,542.2065;Float;True;Property;_RampTex;RampTex;3;0;Create;True;0;0;False;0;None;81799091b95992643ad1e937aa5d38d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;504.0709,346.2289;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;253.4306,552.6329;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;549.9473,36.04095;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;21;806.4471,299.9232;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;858.593,33.82331;Float;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1101.7,34.39999;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Dissolve/Ramp;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;7;0;5;1
WireConnection;10;0;9;0
WireConnection;22;0;16;0
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;15;1;8;0
WireConnection;15;2;22;0
WireConnection;11;0;15;0
WireConnection;18;0;15;0
WireConnection;6;1;11;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;17;0;3;4
WireConnection;17;1;2;4
WireConnection;17;2;4;4
WireConnection;17;3;18;0
WireConnection;24;0;6;0
WireConnection;24;1;23;0
WireConnection;14;0;24;0
WireConnection;14;1;1;0
WireConnection;14;2;6;4
WireConnection;21;0;17;0
WireConnection;20;0;14;0
WireConnection;20;3;21;0
WireConnection;0;0;20;0
ASEEND*/
//CHKSM=2C759E0E1EA77E6D027DF430BEF1F3B3228778DA