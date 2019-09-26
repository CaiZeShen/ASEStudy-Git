// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShenLin/Post/DesColor"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_DesColor("DesColor", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform half _DesColor;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode7 = tex2D( _MainTex, uv_MainTex );
				float3 desaturateInitialColor17 = tex2DNode7.rgb;
				float desaturateDot17 = dot( desaturateInitialColor17, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar17 = lerp( desaturateInitialColor17, desaturateDot17.xxx, 1.0 );
				float4 lerpResult11 = lerp( tex2DNode7 , float4( desaturateVar17 , 0.0 ) , _DesColor);
				

				finalColor = lerpResult11;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
266;422;1466;772;1355.193;881.8282;2.247024;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-919.1639,-174.5964;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;18;-250.2448,-521.4833;Float;False;335;302.9999;;1;17;感官上的去色,用到dot运算,效率比max差,效果更佳;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;7;-710.664,-174.7964;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;16;-176.2135,360.1711;Float;False;582.4703;369.7058;;2;14;15;和max一样去饱和度,这个运算量更大;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-174.2135,-39.82895;Float;False;431;331;;2;9;10;去饱和度;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;267.5156,-452.9308;Half;False;Property;_DesColor;DesColor;1;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;17;-200.2448,-471.4833;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;10;41.7865,71.17105;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;14;-126.2135,410.1711;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;15;149.2568,430.8768;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;11;577.3111,-116.2992;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;9;-110.7314,-16.79324;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;776.5245,-114.4703;Half;False;True;2;Half;ASEMaterialInspector;0;2;ShenLin/Post/DesColor;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;7;0;8;0
WireConnection;17;0;7;0
WireConnection;10;0;9;0
WireConnection;10;1;7;3
WireConnection;14;0;7;0
WireConnection;15;0;14;1
WireConnection;15;2;14;3
WireConnection;11;0;7;0
WireConnection;11;1;17;0
WireConnection;11;2;12;0
WireConnection;9;0;7;1
WireConnection;9;1;7;2
WireConnection;5;0;11;0
ASEEND*/
//CHKSM=9FCD61023489FFD574F71C116E90EEEC5608F167