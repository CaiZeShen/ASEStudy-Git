// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Vert/Grassland"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_Color("Color", Color) = (0.4811321,0.4811321,0.4811321,1)
		_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_NoiseTex("NoiseTex", 2D) = "white" {}
		_Till("Till", Float) = 1
		_SpeedAndStrength("SpeedAndStrength", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Off
		ColorMask RGBA
		ZWrite On
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

			uniform sampler2D _NoiseTex;
			uniform float _Till;
			uniform half4 _SpeedAndStrength;
			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform half4 _Color;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult12 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 appendResult22 = (float2(_SpeedAndStrength.x , _SpeedAndStrength.y));
				float4 tex2DNode9 = tex2Dlod( _NoiseTex, float4( (appendResult12*_Till + ( _Time.y * appendResult22 )), 0, 0.0) );
				float2 appendResult28 = (float2(_SpeedAndStrength.z , _SpeedAndStrength.w));
				float2 uv013 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 break29 = ( tex2DNode9.r * appendResult28 * uv013.y );
				float3 appendResult10 = (float3(break29.x , 0.0 , break29.y));
				
				float2 vertexToFrag37 = (appendResult12*_Till + ( _Time.y * appendResult22 ));
				o.ase_texcoord.zw = vertexToFrag37;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				float3 vertexValue = appendResult10;

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
				float2 vertexToFrag37 = i.ase_texcoord.zw;
				float4 tex2DNode9 = tex2D( _NoiseTex, vertexToFrag37 );
				float2 uv013 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				clip( tex2DNode2.a - 0.5);
				
				
				finalColor = ( ( _MainColor * tex2DNode2 * i.ase_color ) + ( _Color * tex2DNode9.r * uv013.y ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
266;424;1242;636;1282.49;211.1123;2.519902;True;False
Node;AmplifyShaderEditor.Vector4Node;24;-1527.884,767.057;Half;False;Property;_SpeedAndStrength;SpeedAndStrength;5;0;Create;True;0;0;False;0;0,0,0,0;0.3,0.2,-0.45,-0.12;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-1367.309,423.9009;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;25;-1215.283,605.6563;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1195.085,794.3568;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-941.2848,626.2557;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1075.583,341.6373;Float;False;Property;_Till;Till;4;0;Create;True;0;0;False;0;1;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1141.911,454.7009;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;34;-742.1952,472.9076;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexToFragmentNode;37;-491.9308,471.7438;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-431.4498,-274.5137;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.6896392,0.9150943,0.3237362,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-967.9701,915.5573;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-141.1225,864.0912;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;8;-383.4498,109.4865;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-495.45,-98.51359;Float;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;9b5376f20309ca648ad1ab437a1b6e12;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-142.8984,215.1771;Half;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;0.4811321,0.4811321,0.4811321,1;0.3397359,0.3773585,0.1014596,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-215.0493,445.2762;Float;True;Property;_NoiseTex;NoiseTex;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;190.9897,473.559;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;133.9303,301.1776;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-45.36996,-103.1536;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;29;352.2602,474.4218;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;33;328.6726,54.50425;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;643.0482,469.3761;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClipNode;5;558.061,172.6897;Float;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;835.027,174.8273;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Vert/Grassland;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=TransparentCutout=RenderType;Queue=AlphaTest=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;22;0;24;1
WireConnection;22;1;24;2
WireConnection;26;0;25;2
WireConnection;26;1;22;0
WireConnection;12;0;11;1
WireConnection;12;1;11;3
WireConnection;34;0;12;0
WireConnection;34;1;35;0
WireConnection;34;2;26;0
WireConnection;37;0;34;0
WireConnection;28;0;24;3
WireConnection;28;1;24;4
WireConnection;9;1;37;0
WireConnection;16;0;9;1
WireConnection;16;1;28;0
WireConnection;16;2;13;2
WireConnection;32;0;31;0
WireConnection;32;1;9;1
WireConnection;32;2;13;2
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;8;0
WireConnection;29;0;16;0
WireConnection;33;0;1;0
WireConnection;33;1;32;0
WireConnection;10;0;29;0
WireConnection;10;2;29;1
WireConnection;5;0;33;0
WireConnection;5;1;2;4
WireConnection;0;0;5;0
WireConnection;0;1;10;0
ASEEND*/
//CHKSM=6CC733D5A9604D981818331F70C0BCAA408FCB74