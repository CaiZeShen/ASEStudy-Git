// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Vert/Normal"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Strength("Strength", Float) = 0
		[NoScaleOffset]_MaskTex("MaskTex", 2D) = "white" {}
		_Speed("Speed", Float) = 0
		_BottomColor("BottomColor", Color) = (0,0,0,0)
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
				float3 ase_normal : NORMAL;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform half _Strength;
			uniform sampler2D _MaskTex;
			uniform half _Speed;
			uniform half4 _BottomColor;
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv15 = v.ase_texcoord1 * float2( 1,1 ) + float2( 0,0 );
				float mulTime16 = _Time.y * _Speed;
				float4 tex2DNode12 = tex2Dlod( _MaskTex, float4( ( uv15 + mulTime16 ), 0, 0.0) );
				
				o.ase_texcoord.xy = v.ase_texcoord1.xy;
				o.ase_texcoord.zw = v.ase_texcoord.xy;
				float3 vertexValue = ( v.ase_normal * _Strength * tex2DNode12.r );

				v.vertex.xyz += vertexValue;

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 uv15 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime16 = _Time.y * _Speed;
				float4 tex2DNode12 = tex2D( _MaskTex, ( uv15 + mulTime16 ) );
				float4 lerpResult21 = lerp( _BottomColor , _MainColor , tex2DNode12.r);
				float2 uv_MainTex = i.ase_texcoord.zw * _MainTex_ST.xy + _MainTex_ST.zw;
				
				
				finalColor = ( lerpResult21 * tex2D( _MainTex, uv_MainTex ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
174;421;1242;642;2030.614;398.9159;2.57587;True;False
Node;AmplifyShaderEditor.RangedFloatNode;13;-1045.627,900.1448;Half;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-920.9159,702.7484;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-872.7191,903.1719;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-633.8599,703.422;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-463.5117,674.0413;Float;True;Property;_MaskTex;MaskTex;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-295.4181,-124.7513;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.1745283,1,0.9847683,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-319.899,-360.0324;Half;False;Property;_BottomColor;BottomColor;5;0;Create;True;0;0;False;0;0,0,0,0;0,0.6452267,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;7;-360.515,418.7483;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-332.7354,564.4259;Half;False;Property;_Strength;Strength;2;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;10.68481,-223.8274;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;12.03133,56.52277;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;074111debff35d54d84ae91d8669ab73;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;370.6028,375.2521;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;402.7979,35.09289;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;656.7726,32.35902;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Vert/Normal;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;16;0;13;0
WireConnection;15;0;5;0
WireConnection;15;1;16;0
WireConnection;12;1;15;0
WireConnection;21;0;17;0
WireConnection;21;1;3;0
WireConnection;21;2;12;1
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;8;2;12;1
WireConnection;1;0;21;0
WireConnection;1;1;2;0
WireConnection;0;0;1;0
WireConnection;0;1;8;0
ASEEND*/
//CHKSM=91DBBA139D6A51B096BFB0E6C0EBE08CCB794596