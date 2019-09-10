// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Vert/Blood"
{
	Properties
	{
		[HDR]_FrontColor("FrontColor", Color) = (1,1,1,1)
		[HDR]_BackColor("BackColor", Color) = (1,1,1,1)
		[NoScaleOffset]_NoiseTex("NoiseTex", 2D) = "white" {}
		_Speed("Speed", Float) = 0
		_Strength("Strength", Float) = 0.2
		_Scale("Scale", Float) = 0.2
		_Height("Height", Float) = -0.41
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
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform half4 _BackColor;
			uniform half4 _FrontColor;
			uniform sampler2D _NoiseTex;
			uniform half _Scale;
			uniform half _Speed;
			uniform half _Strength;
			uniform half _Height;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float4 transform17 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float4 break27 = ( float4( ase_worldPos , 0.0 ) - transform17 );
				float vertexToFrag54 = break27.y;
				o.ase_texcoord.x = vertexToFrag54;
				float2 appendResult39 = (float2(break27.x , break27.z));
				float mulTime46 = _Time.y * _Speed;
				float2 vertexToFrag53 = (appendResult39*_Scale + mulTime46);
				o.ase_texcoord.yz = vertexToFrag53;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				float3 vertexValue =  float3(0,0,0) ;

				v.vertex.xyz += vertexValue;

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i , half ase_vface : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float4 lerpResult12 = lerp( _BackColor , _FrontColor , (ase_vface*0.5 + 0.5));
				float vertexToFrag54 = i.ase_texcoord.x;
				float2 vertexToFrag53 = i.ase_texcoord.yz;
				clip( step( ( vertexToFrag54 + ( ( tex2D( _NoiseTex, vertexToFrag53 ).r - 0.5 ) * _Strength ) + _Height ) , 0.0 ) - 0.5);
				
				
				finalColor = lerpResult12;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;7;1906;1004;1235.796;8.944006;1.6;True;False
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;17;-2717.339,856.9019;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-2717.285,693.8731;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-2363.328,795.8181;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;27;-2190.274,795.973;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;47;-2041.675,1073.015;Half;False;Property;_Speed;Speed;3;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1968.99,987.5583;Half;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1790.476,876.3299;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-1877.675,1082.015;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;44;-1614.117,878.7155;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexToFragmentNode;53;-1368.785,879.8724;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;35;-1072.039,847.6517;Float;True;Property;_NoiseTex;NoiseTex;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-750.8442,871.5159;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-806.9836,1048.429;Half;False;Property;_Strength;Strength;4;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;11;-202.195,396.3267;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;54;-1088.356,651.2251;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-569.7531,878.236;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-514.4648,989.8271;Half;False;Property;_Height;Height;6;0;Create;True;0;0;False;0;-0.41;-0.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-184.4167,201.4482;Half;False;Property;_BackColor;BackColor;1;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.9811321,0.245283,0.245283,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-186.8279,11.55723;Half;False;Property;_FrontColor;FrontColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;14;-19.65534,395.2473;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-301.2629,653.7688;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;37;-34.11649,654.4245;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;242.7843,167.2261;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClipNode;5;558.061,172.6897;Float;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;835.027,174.8273;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Vert/Blood;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=TransparentCutout=RenderType;Queue=AlphaTest=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;28;0;24;0
WireConnection;28;1;17;0
WireConnection;27;0;28;0
WireConnection;39;0;27;0
WireConnection;39;1;27;2
WireConnection;46;0;47;0
WireConnection;44;0;39;0
WireConnection;44;1;57;0
WireConnection;44;2;46;0
WireConnection;53;0;44;0
WireConnection;35;1;53;0
WireConnection;49;0;35;1
WireConnection;54;0;27;1
WireConnection;50;0;49;0
WireConnection;50;1;56;0
WireConnection;14;0;11;0
WireConnection;40;0;54;0
WireConnection;40;1;50;0
WireConnection;40;2;51;0
WireConnection;37;0;40;0
WireConnection;12;0;10;0
WireConnection;12;1;3;0
WireConnection;12;2;14;0
WireConnection;5;0;12;0
WireConnection;5;1;37;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=2CBFD63808D32DFE0E6B198997F70BB711BA20C9