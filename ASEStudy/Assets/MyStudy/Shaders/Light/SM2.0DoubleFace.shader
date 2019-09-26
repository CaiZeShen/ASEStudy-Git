// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Light/SM2.0DoubleFace"
{
	Properties
	{
		[HDR]_FrontColor("FrontColor", Color) = (1,1,1,1)
		[HDR]_BackColor("BackColor", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
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
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform half4 _FrontColor;
			uniform half4 _BackColor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
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
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float dotResult5 = dot( ase_worldViewDir , ase_worldNormal );
				float4 lerpResult24 = lerp( _FrontColor , _BackColor , (sign( dotResult5 )*0.5 + 0.5));
				
				
				finalColor = lerpResult24;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
256;217;1466;729;1481.118;344.7814;1.818233;True;False
Node;AmplifyShaderEditor.CommentaryNode;22;-1001.789,426.4529;Float;False;864.4841;350.4942;代替face节点;4;21;5;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-869.429,472.9312;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;7;-872.9231,625.2218;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;5;-563.3353,477.8626;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SignOpNode;21;-291.3033,476.4533;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-709.9257,121.1004;Float;False;309.6;188;ShaderModle3.0以下用可能会有问题;1;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;23;-68.23409,477.3413;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-79.18216,180.2299;Half;False;Property;_BackColor;BackColor;1;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.9245283,0.3009078,0.3009078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-74.45638,-75.99946;Half;False;Property;_FrontColor;FrontColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FaceVariableNode;19;-607.5258,189.9008;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;436.1058,66.68535;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;851.2262,96.09895;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Light/SM2.0DoubleFace;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;21;0;5;0
WireConnection;23;0;21;0
WireConnection;24;0;3;0
WireConnection;24;1;25;0
WireConnection;24;2;23;0
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=C6BD3AAB4F7C3AC9CEAF38EA3661D1AFDBE1C575