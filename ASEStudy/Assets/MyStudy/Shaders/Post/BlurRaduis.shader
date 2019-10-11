// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShenLin/Post/BlurRaduis"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Offset("Offset", Float) = 0
		_AnchorX("AnchorX", Range( 0 , 1)) = 0
		_AnchorY("AnchorY", Range( 0 , 1)) = 0
		_Count("Count", Int) = 0
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
			
			uniform int _Count;
			uniform half _AnchorX;
			uniform half _AnchorY;
			uniform half _Offset;

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
				float localMyCustomExpression1_g1 = ( 0.0 );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult10 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				float2 UV1_g1 = appendResult10;
				float3 FinColor1_g1 = float3( 0,0,0 );
				int Count1_g1 = _Count;
				sampler2D MainTex1_g1 = _MainTex;
				float2 appendResult17 = (float2(_AnchorX , _AnchorY));
				float2 Center1_g1 = appendResult17;
				float BlurFac1_g1 = ( _Offset * 0.01 );
				float2 dir = UV1_g1 - Center1_g1;
				for(int i =0 ;i < Count1_g1; i++){
				UV1_g1 = UV1_g1 - dir * BlurFac1_g1 * i;
				FinColor1_g1 += tex2D(MainTex1_g1,UV1_g1);
				}
				FinColor1_g1 /= Count1_g1;
				

				finalColor = half4( FinColor1_g1 , 0.0 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
347;265;1466;837;1850.867;794.3566;2.094673;True;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-1143.036,204.9951;Half;False;Property;_AnchorX;AnchorX;1;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1141.036,278.9952;Half;False;Property;_AnchorY;AnchorY;2;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;9;-1162.621,23.86755;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-543.4404,322.6525;Half;False;Property;_Offset;Offset;0;0;Create;True;0;0;False;0;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-532.5861,-78.86389;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;35;-518.7374,74.19608;Float;False;Property;_Count;Count;3;0;Create;True;0;0;False;0;0;10;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-356.3792,277.184;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-787.0354,232.9951;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-889.6208,51.86757;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;36;-144.2209,-89.815;Float;False;BlurRaduis;-1;;1;682a8a1895556a540a55fc660ec6ed63;0;5;2;FLOAT2;0,0;False;3;INT;0;False;4;SAMPLER2D;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;168.1808,-89.69135;Half;False;True;2;Half;ASEMaterialInspector;0;2;ShenLin/Post/BlurRaduis;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;11;0;13;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;10;0;9;1
WireConnection;10;1;9;2
WireConnection;36;2;10;0
WireConnection;36;3;35;0
WireConnection;36;4;8;0
WireConnection;36;5;17;0
WireConnection;36;6;11;0
WireConnection;5;0;36;0
ASEEND*/
//CHKSM=7C09B596B739A8AB7897BA57933691C871AD5DEC