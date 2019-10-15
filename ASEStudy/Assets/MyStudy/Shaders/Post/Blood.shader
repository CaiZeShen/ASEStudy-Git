// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShenLin/Post/Blood"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Min("Min", Float) = 0
		_Max("Max", Float) = 0
		_Speed("Speed", Float) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform half4 _Color0;
			uniform half _Min;
			uniform half _Max;
			uniform half _Speed;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult10 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				float2 temp_output_39_0 = (appendResult10*2.0 + -1.0);
				float2 break61 = temp_output_39_0;
				float2 appendResult59 = (float2(( break61.x * ( _ScreenParams.x / _ScreenParams.y ) ) , break61.y));
				float smoothstepResult44 = smoothstep( _Min , _Max , length( appendResult59 ));
				float mulTime63 = _Time.y * _Speed;
				float temp_output_1_0_g1 = abs( (frac( mulTime63 )*2.0 + -1.0) );
				float4 lerpResult48 = lerp( tex2D( _MainTex, appendResult10 ) , _Color0 , ( _Color0.a * smoothstepResult44 * ( temp_output_1_0_g1 * temp_output_1_0_g1 * ( 3.0 - ( temp_output_1_0_g1 * 2.0 ) ) ) ));
				

				finalColor = lerpResult48;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
466;125;1466;855;2175.281;1172.389;2.133468;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;9;-1545.429,-55.31062;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1272.429,-27.31061;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenParams;56;-931.6303,343.5932;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;39;-1076.963,184.9084;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-667.0872,638.5012;Half;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;57;-744.4304,366.9932;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;61;-858.268,187.9978;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;63;-507.3274,643.0941;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-560.5014,186.3734;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;66;-323.7349,641.9974;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-394.7305,184.6526;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;69;-174.3628,641.6511;Float;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-170.1075,368.1733;Half;False;Property;_Min;Min;0;0;Create;True;0;0;False;0;0;1.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-162.4826,462.0568;Half;False;Property;_Max;Max;1;0;Create;True;0;0;False;0;0;2.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;72;42.04507,643.1052;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;60;-232.0224,185.9526;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;74;187.0893,642.2723;Float;True;Smooth;-1;;1;925377fd32ce4cf4693aaf8b2c0e8af1;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;177.3469,119.0883;Half;False;Property;_Color0;Color 0;3;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0.6588235;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-714.886,-143.8639;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;44;159.9555,339.8585;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-755.5674,997.3388;Float;False;1049.759;305.1547;;3;43;41;40;四方形mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;436.1522,253.7158;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-317.6927,-46.04489;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;40;-478.0173,1047.339;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;48;684.9575,81.59702;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;-12.36389,1048.818;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;41;-285.0275,1048.818;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;907.3087,78.80356;Half;False;True;2;Half;ASEMaterialInspector;0;2;ShenLin/Post/Blood;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1034.271,-609.1531;Float;False;653.4988;151.2032;Comment;0;如果是这么简单的残血效果,建议做一半的图设配在ui上做,省下shader计算;1,1,1,1;0;0
WireConnection;10;0;9;1
WireConnection;10;1;9;2
WireConnection;39;0;10;0
WireConnection;57;0;56;1
WireConnection;57;1;56;2
WireConnection;61;0;39;0
WireConnection;63;0;65;0
WireConnection;58;0;61;0
WireConnection;58;1;57;0
WireConnection;66;0;63;0
WireConnection;59;0;58;0
WireConnection;59;1;61;1
WireConnection;69;0;66;0
WireConnection;72;0;69;0
WireConnection;60;0;59;0
WireConnection;74;1;72;0
WireConnection;44;0;60;0
WireConnection;44;1;45;0
WireConnection;44;2;55;0
WireConnection;49;0;47;4
WireConnection;49;1;44;0
WireConnection;49;2;74;0
WireConnection;37;0;8;0
WireConnection;37;1;10;0
WireConnection;40;0;39;0
WireConnection;48;0;37;0
WireConnection;48;1;47;0
WireConnection;48;2;49;0
WireConnection;43;0;41;0
WireConnection;43;1;41;1
WireConnection;41;0;40;0
WireConnection;5;0;48;0
ASEEND*/
//CHKSM=D5594C828DF09605D35DAE1E06C7368D7D531BA1