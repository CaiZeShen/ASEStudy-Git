// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Dissolve/Fire"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_ShapTex("ShapTex", 2D) = "white" {}
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
			#include "UnityShaderVariables.cginc"


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

			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseTex_ST;
			uniform sampler2D _ShapTex;
			uniform float4 _ShapTex_ST;
			
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
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv0_NoiseTex = i.ase_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float2 appendResult20 = (float2(-0.2 , -1.0));
				float4 tex2DNode5 = tex2D( _NoiseTex, ( uv0_NoiseTex + ( appendResult20 * _Time.y ) ) );
				float2 uv0_ShapTex = i.ase_texcoord.xy * _ShapTex_ST.xy + _ShapTex_ST.zw;
				float2 appendResult37 = (float2(-0.08 , 0.4));
				float4 appendResult11 = (float4(( _MainColor * tex2DNode2 * i.ase_color ).rgb , ( _MainColor.a * tex2DNode2.a * i.ase_color.a * step( tex2DNode5.r , tex2D( _ShapTex, ( uv0_ShapTex + ( tex2DNode5.r * uv0_ShapTex.y * appendResult37 ) ) ).r ) )));
				
				
				finalColor = appendResult11;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;1;1906;1010;301.4702;245.265;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-1807.63,810.2432;Float;False;Constant;_VSpeed;VSpeed;3;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1818.63,728.2431;Half;False;Constant;_USpeed;USpeed;3;0;Create;True;0;0;False;0;-0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1592.63,763.2431;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;25;-1558.53,905.8431;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1314.34,762.7912;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1436.53,566.8431;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-967.4073,1089.034;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-968.4072,1005.034;Half;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;-0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1114.829,567.9431;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-770.7076,1026.834;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-906.5068,851.8332;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-925.204,538.6718;Float;True;Property;_NoiseTex;NoiseTex;2;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-588.9064,926.734;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-410.3069,854.6329;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-236.8343,828.1951;Float;True;Property;_ShapTex;ShapTex;3;0;Create;True;0;0;False;0;None;58a9a064bf67e76449bda98bda46c06f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;92fdfeae3b21ac143a04fe28b56f63ed;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;8;53.4961,561.0723;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;4;54.95589,287.6129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;350.7634,376.702;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;550.9363,62.35437;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;753,63;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Dissolve/Fire;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;27;0;20;0
WireConnection;27;1;25;2
WireConnection;21;0;17;0
WireConnection;21;1;27;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;5;1;21;0
WireConnection;38;0;5;1
WireConnection;38;1;33;2
WireConnection;38;2;37;0
WireConnection;34;0;33;0
WireConnection;34;1;38;0
WireConnection;28;1;34;0
WireConnection;8;0;5;1
WireConnection;8;1;28;1
WireConnection;10;0;3;4
WireConnection;10;1;2;4
WireConnection;10;2;4;4
WireConnection;10;3;8;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;11;0;1;0
WireConnection;11;3;10;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=4FC4D16C98F09DC80AC0D0B8839743EBCB0EB67B