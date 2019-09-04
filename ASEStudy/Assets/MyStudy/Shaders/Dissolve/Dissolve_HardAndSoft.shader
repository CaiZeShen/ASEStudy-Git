// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Dissolve/HardAndSoft"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 1)) = 0.4587571
		_Hardness("Hardness", Range( 0 , 0.99)) = 0
		[HDR]_Outline("Outline", Color) = (1,0.1264682,0.0990566,1)
		_OutlineWidth("OutlineWidth", Range( 0 , 1)) = 0
		[Enum(Material,0,Particle,1)]_DissovleMode("DissovleMode", Range( 0 , 1)) = 0
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
			};

			uniform half4 _Outline;
			uniform half _DissovleMode;
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseTex_ST;
			uniform half _Dissolve;
			uniform half _OutlineWidth;
			uniform half _Hardness;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv147 = v.ase_texcoord1 * float2( 1,1 ) + float2( 0,0 );
				float lerpResult49 = lerp( _Dissolve , uv147.x , _DissovleMode);
				float temp_output_43_0 = ( lerpResult49 * ( 1.0 + _OutlineWidth ) );
				half Hardness19 = _Hardness;
				float temp_output_39_0 = ( 1.0 + ( 1.0 - Hardness19 ) );
				float vertexToFrag45 = ( temp_output_43_0 * temp_output_39_0 );
				o.ase_texcoord1.z = vertexToFrag45;
				float vertexToFrag46 = ( ( temp_output_43_0 - _OutlineWidth ) * temp_output_39_0 );
				o.ase_texcoord1.w = vertexToFrag46;
				
				o.ase_texcoord = v.ase_texcoord2;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
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
				float4 uv251 = i.ase_texcoord;
				uv251.xy = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				half DissovlelMode50 = _DissovleMode;
				float4 lerpResult53 = lerp( _Outline , uv251 , DissovlelMode50);
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv_NoiseTex = i.ase_texcoord1.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float temp_output_12_0 = ( tex2D( _NoiseTex, uv_NoiseTex ).r + 1.0 );
				float vertexToFrag45 = i.ase_texcoord1.z;
				float temp_output_2_0_g5 = _Hardness;
				float4 lerpResult21 = lerp( lerpResult53 , ( _MainColor * tex2DNode2 * i.ase_color ) , saturate( ( ( ( temp_output_12_0 - vertexToFrag45 ) - temp_output_2_0_g5 ) / ( 1.0 - temp_output_2_0_g5 ) ) ));
				float vertexToFrag46 = i.ase_texcoord1.w;
				float temp_output_2_0_g6 = _Hardness;
				float4 appendResult35 = (float4(lerpResult21.rgb , ( _MainColor.a * tex2DNode2.a * i.ase_color.a * saturate( ( ( ( temp_output_12_0 - vertexToFrag46 ) - temp_output_2_0_g6 ) / ( 1.0 - temp_output_2_0_g6 ) ) ) )));
				
				
				finalColor = appendResult35;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
307;248;1146;602;2061.772;946.0297;3.107042;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-731.7072,877.5887;Half;False;Property;_Hardness;Hardness;4;0;Create;True;0;0;False;0;0;0.609;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2402.109,1040.186;Half;False;Property;_OutlineWidth;OutlineWidth;6;0;Create;True;0;0;False;0;0;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-416.0665,882.8813;Half;False;Hardness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2615.159,672.6276;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-2631.874,588.6771;Half;False;Property;_Dissolve;Dissolve;3;0;Create;True;0;0;False;0;0.4587571;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2637.615,838.1874;Half;False;Property;_DissovleMode;DissovleMode;7;1;[Enum];Create;True;2;Material;0;Particle;1;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1744.479,896.1315;Float;False;19;Hardness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-2218.18,695.1318;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-2125.262,960.9139;Float;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-1556.124,899.3395;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1995.492,847.4473;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1833.066,1019.682;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1393.606,875.8525;Float;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1197.048,833.4639;Float;True;Property;_NoiseTex;NoiseTex;2;0;Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1109.839,658.443;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1066.242,1101.635;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;46;-907.3152,1100.588;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;45;-932.9158,662.1871;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-886.3121,862.8268;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2283.18,836.1318;Half;False;DissovlelMode;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-114.3,-122;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-649.9131,1080.45;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-170.3,54.99999;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;908c9641b9abfd846bf19bccd670267d;80ab37a9e4f49c842903bb43bdd7bcd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-128.9576,-400.2105;Float;False;2;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-121.7528,-575.4744;Half;False;Property;_Outline;Outline;5;1;[HDR];Create;True;0;0;False;0;1,0.1264682,0.0990566,1;0.9921569,0.02048423,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;52;-132.0121,-235.4272;Float;False;50;DissovlelMode;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-629.522,667.0804;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;4;-50.34411,261.613;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;53;303.7679,-270.0557;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;25;-419.5572,1080.351;Float;True;SmoothSetp_Simple;-1;;6;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;15;-399.1666,666.9811;Float;True;SmoothSetp_Simple;-1;;5;a372926429886d84e9db1f91b3bfb475;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;480.0324,470.2263;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;549.9473,52.42534;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;857.5276,50.83125;Float;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1155.9,56.70006;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Dissolve/HardAndSoft;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;0
WireConnection;49;0;14;0
WireConnection;49;1;47;1
WireConnection;49;2;48;0
WireConnection;42;1;32;0
WireConnection;38;0;20;0
WireConnection;43;0;49;0
WireConnection;43;1;42;0
WireConnection;33;0;43;0
WireConnection;33;1;32;0
WireConnection;39;1;38;0
WireConnection;16;0;43;0
WireConnection;16;1;39;0
WireConnection;26;0;33;0
WireConnection;26;1;39;0
WireConnection;46;0;26;0
WireConnection;45;0;16;0
WireConnection;12;0;11;1
WireConnection;50;0;48;0
WireConnection;24;0;12;0
WireConnection;24;1;46;0
WireConnection;13;0;12;0
WireConnection;13;1;45;0
WireConnection;53;0;23;0
WireConnection;53;1;51;0
WireConnection;53;2;52;0
WireConnection;25;1;24;0
WireConnection;25;2;17;0
WireConnection;15;1;13;0
WireConnection;15;2;17;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;34;0;3;4
WireConnection;34;1;2;4
WireConnection;34;2;4;4
WireConnection;34;3;25;0
WireConnection;21;0;53;0
WireConnection;21;1;1;0
WireConnection;21;2;15;0
WireConnection;35;0;21;0
WireConnection;35;3;34;0
WireConnection;0;0;35;0
ASEEND*/
//CHKSM=53208B3DEE0F8C4630A6CE3EB831C083CF38D438