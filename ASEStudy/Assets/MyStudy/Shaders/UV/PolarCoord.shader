// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/UV/PolarCoord"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		_ScaleAndOffset("ScaleAndOffset", Vector) = (1,1,0,0)
		_Exp("Exp", Float) = 1
		_Rotation("Rotation", Float) = 0
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
				float4 ase_color : COLOR;
			};

			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform half _Rotation;
			uniform half _Exp;
			uniform half4 _ScaleAndOffset;
			
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
				float2 uv011 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float cos29 = cos( ( ( 2.0 * UNITY_PI ) * ( 1.0 - length( (uv011*2.0 + -1.0) ) ) * _Rotation ) );
				float sin29 = sin( ( ( 2.0 * UNITY_PI ) * ( 1.0 - length( (uv011*2.0 + -1.0) ) ) * _Rotation ) );
				float2 rotator29 = mul( uv011 - float2( 0.5,0.5 ) , float2x2( cos29 , -sin29 , sin29 , cos29 )) + float2( 0.5,0.5 );
				float2 temp_output_12_0 = (rotator29*2.0 + -1.0);
				float2 break14 = temp_output_12_0;
				float2 appendResult20 = (float2(pow( length( temp_output_12_0 ) , _Exp ) , ( ( atan2( break14.y , break14.x ) / ( 2.0 * UNITY_PI ) ) + 0.5 )));
				float2 appendResult23 = (float2(_ScaleAndOffset.x , _ScaleAndOffset.y));
				float2 appendResult24 = (float2(_ScaleAndOffset.z , _ScaleAndOffset.w));
				
				
				finalColor = ( _MainColor * tex2D( _MainTex, (appendResult20*appendResult23 + appendResult24) ) * i.ase_color );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;7;1906;1004;4621.323;1095.981;3.127077;True;False
Node;AmplifyShaderEditor.CommentaryNode;38;-3450.8,6.920655;Float;False;1401.215;744.0179;;8;29;34;36;33;30;35;31;11;旋涡旋轉;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-3400.8,56.92065;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-3031.45,319.5583;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;35;-2826.722,318.6945;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;30;-2689.585,202.3494;Float;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2660.805,319.3474;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2638.495,571.363;Half;False;Property;_Rotation;Rotation;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-2459.114,272.027;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2018.931,-12.62927;Float;False;1908.505;746.5641;;13;21;20;24;23;19;22;17;37;16;18;14;12;40;极坐标;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;29;-2268.939,58.4983;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;12;-1944.714,91.40307;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;14;-1693.237,357.8245;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ATan2OpNode;16;-1435.337,363.4244;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1365.557,43.16891;Float;False;467.011;279.6011;;2;25;26;边缘变细;1,1,1,1;0;0
Node;AmplifyShaderEditor.PiNode;18;-1492.516,601.8323;Float;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;-1196.916,431.2322;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;37;-1602.441,95.19716;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1340.011,188.2438;Half;False;Property;_Exp;Exp;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-1146.313,105.0437;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;22;-724.6545,254.9716;Half;False;Property;_ScaleAndOffset;ScaleAndOffset;2;0;Create;True;0;0;False;0;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-966.9765,429.9321;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-501.5238,193.4786;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-491.5238,311.4785;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-745.6683,111.131;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;21;-319.0511,108.1445;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;4;54.95589,287.6129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;1;[NoScaleOffset];Create;True;0;0;False;0;84508b93f15f2b64386ec07486afc7a3;908c9641b9abfd846bf19bccd670267d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;447,63;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/UV/PolarCoord;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;31;0;11;0
WireConnection;35;0;31;0
WireConnection;33;0;35;0
WireConnection;34;0;30;0
WireConnection;34;1;33;0
WireConnection;34;2;36;0
WireConnection;29;0;11;0
WireConnection;29;2;34;0
WireConnection;12;0;29;0
WireConnection;14;0;12;0
WireConnection;16;0;14;1
WireConnection;16;1;14;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;37;0;12;0
WireConnection;25;0;37;0
WireConnection;25;1;26;0
WireConnection;19;0;17;0
WireConnection;23;0;22;1
WireConnection;23;1;22;2
WireConnection;24;0;22;3
WireConnection;24;1;22;4
WireConnection;20;0;25;0
WireConnection;20;1;19;0
WireConnection;21;0;20;0
WireConnection;21;1;23;0
WireConnection;21;2;24;0
WireConnection;2;1;21;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=88F8D74F31B79113DE5727DA8F6349B71913AF70