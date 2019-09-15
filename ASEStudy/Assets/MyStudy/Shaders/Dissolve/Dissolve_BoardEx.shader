// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Dissolve/BoardEx"
{
	Properties
	{
		_FirstTex("FirstTex", 2D) = "white" {}
		_SecondTex("SecondTex", 2D) = "white" {}
		_DissovleDir("DissovleDir", 2D) = "white" {}
		[NoScaleOffset]_DissovleShape("DissovleShape", 2D) = "white" {}
		_Till("Till", Int) = 0
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[HDR]_OutLineColor("OutLineColor", Color) = (0,0,0,0)
		_OutlineWidth("OutlineWidth", Float) = 0
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
			};

			uniform sampler2D _SecondTex;
			uniform float4 _SecondTex_ST;
			uniform sampler2D _FirstTex;
			uniform float4 _FirstTex_ST;
			uniform sampler2D _DissovleShape;
			uniform int _Till;
			uniform float4 _DissovleShape_ST;
			uniform float _Dissolve;
			uniform sampler2D _DissovleDir;
			uniform float4 _DissovleDir_ST;
			uniform half4 _OutLineColor;
			uniform half _OutlineWidth;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
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
				float2 uv_SecondTex = i.ase_texcoord.xy * _SecondTex_ST.xy + _SecondTex_ST.zw;
				float2 uv_FirstTex = i.ase_texcoord.xy * _FirstTex_ST.xy + _FirstTex_ST.zw;
				float2 uv0_DissovleShape = i.ase_texcoord.xy * _DissovleShape_ST.xy + _DissovleShape_ST.zw;
				float4 tex2DNode19 = tex2D( _DissovleShape, ( _Till * uv0_DissovleShape ) );
				float2 uv0_DissovleDir = i.ase_texcoord.xy * _DissovleDir_ST.xy + _DissovleDir_ST.zw;
				float4 tex2DNode5 = tex2D( _DissovleDir, ( floor( ( uv0_DissovleDir * _Till ) ) / ( _Till - 1 ) ) );
				float temp_output_6_0 = step( tex2DNode19.r , ( (_Dissolve*2.0 + -1.0) + tex2DNode5.r ) );
				float4 lerpResult17 = lerp( tex2D( _SecondTex, uv_SecondTex ) , tex2D( _FirstTex, uv_FirstTex ) , temp_output_6_0);
				
				
				finalColor = ( lerpResult17 + ( _OutLineColor * ( step( tex2DNode19.r , ( (( _OutlineWidth + _Dissolve )*2.0 + -1.0) + tex2DNode5.r ) ) - temp_output_6_0 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;7;1906;1004;2575.736;1159.005;1.961996;True;False
Node;AmplifyShaderEditor.IntNode;13;-1843.908,891.4019;Float;False;Property;_Till;Till;4;0;Create;True;0;0;False;0;0;15;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1828.619,490.7069;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1513.952,496.8601;Float;False;2;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;11;-1298.643,498.8601;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1515.292,797.0433;Float;False;2;0;INT;0;False;1;INT;1;False;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1121.693,138.0236;Half;False;Property;_OutlineWidth;OutlineWidth;7;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1190.491,301.4966;Float;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1491.474,1071.421;Float;False;0;19;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-1131.307,499.2546;Float;True;2;0;FLOAT2;0,0;False;1;INT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-900.5483,149.2977;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1164.912,999.2947;Float;False;2;2;0;INT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-818.249,471.9319;Float;True;Property;_DissovleDir;DissovleDir;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;39;-692.5483,138.2977;Float;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;28;-743.3558,310.592;Float;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-469.6322,487.1801;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-819.0186,970.1891;Float;True;Property;_DissovleShape;DissovleShape;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;19fa4622a341fe34bbdfc5382579f7d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-434.5483,238.2977;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;41;-200.2047,281.4954;Float;True;2;0;FLOAT;0.11;False;1;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;6;-202.317,494.9526;Float;True;2;0;FLOAT;0.11;False;1;FLOAT;0.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;328.2761,554.1263;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;332.9905,334.1051;Half;False;Property;_OutLineColor;OutLineColor;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.427451,4,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-89.21214,-230.2312;Float;True;Property;_FirstTex;FirstTex;0;0;Create;True;0;0;False;0;908c9641b9abfd846bf19bccd670267d;919f21f72e407cb47bd851f9809fdb7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-92.78874,-5.511863;Float;True;Property;_SecondTex;SecondTex;1;0;Create;True;0;0;False;0;None;ed8a081522edb4c4ba65d05697702ee5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;606.2479,457.5399;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;17;400.3755,-61.0295;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;952.3728,-51.82505;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1376.975,-45.87049;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Dissolve/BoardEx;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;12;0;10;0
WireConnection;12;1;13;0
WireConnection;11;0;12;0
WireConnection;14;0;13;0
WireConnection;15;0;11;0
WireConnection;15;1;14;0
WireConnection;38;0;32;0
WireConnection;38;1;7;0
WireConnection;22;0;13;0
WireConnection;22;1;20;0
WireConnection;5;1;15;0
WireConnection;39;0;38;0
WireConnection;28;0;7;0
WireConnection;29;0;28;0
WireConnection;29;1;5;1
WireConnection;19;1;22;0
WireConnection;40;0;39;0
WireConnection;40;1;5;1
WireConnection;41;0;19;1
WireConnection;41;1;40;0
WireConnection;6;0;19;1
WireConnection;6;1;29;0
WireConnection;34;0;41;0
WireConnection;34;1;6;0
WireConnection;42;0;30;0
WireConnection;42;1;34;0
WireConnection;17;0;16;0
WireConnection;17;1;2;0
WireConnection;17;2;6;0
WireConnection;43;0;17;0
WireConnection;43;1;42;0
WireConnection;0;0;43;0
ASEEND*/
//CHKSM=6CBFF987CE62084FE762BA90D251CBC8A0208174