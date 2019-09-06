// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/Dissolve/Flowmap"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		_UVTex("UVTex", 2D) = "white" {}
		_Disturbance("Disturbance", Range( 0 , 1)) = 0
		[Enum(Material,0,Partical,1)]_DissovleMode("DissovleMode", Range( 0 , 1)) = 0
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
				float4 ase_color : COLOR;
			};

			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _UVTex;
			uniform float4 _UVTex_ST;
			uniform half _Disturbance;
			uniform half _DissovleMode;
			uniform half _Dissolve;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseTex_ST;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord = v.ase_texcoord;
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
				float4 uv0_MainTex = i.ase_texcoord;
				uv0_MainTex.xy = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 appendResult29 = (float2(uv0_MainTex.x , uv0_MainTex.y));
				float2 uv_UVTex = i.ase_texcoord.xy * _UVTex_ST.xy + _UVTex_ST.zw;
				float4 tex2DNode22 = tex2D( _UVTex, uv_UVTex );
				float2 appendResult24 = (float2(tex2DNode22.r , tex2DNode22.g));
				float lerpResult30 = lerp( _Disturbance , uv0_MainTex.w , _DissovleMode);
				float2 lerpResult23 = lerp( appendResult29 , appendResult24 , lerpResult30);
				float4 tex2DNode2 = tex2D( _MainTex, lerpResult23 );
				float lerpResult32 = lerp( _Dissolve , uv0_MainTex.z , _DissovleMode);
				float2 uv0_NoiseTex = i.ase_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float2 lerpResult25 = lerp( uv0_NoiseTex , appendResult24 , float2( 0,0 ));
				float4 appendResult12 = (float4(( _MainColor * tex2DNode2 * i.ase_color ).rgb , ( _MainColor.a * tex2DNode2.a * i.ase_color.a * step( lerpResult32 , tex2D( _NoiseTex, lerpResult25 ).r ) )));
				
				
				finalColor = appendResult12;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
-293;432;1906;1004;2387.788;-40.97757;1.727939;True;False
Node;AmplifyShaderEditor.SamplerNode;22;-1541.23,394.6077;Float;True;Property;_UVTex;UVTex;4;0;Create;True;0;0;False;0;None;f53d659cfc148aa48a70d753b405e639;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1194.409,422.1335;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1046.98,83.71687;Float;False;0;2;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-899.4214,453.58;Half;False;Property;_DissovleMode;DissovleMode;6;1;[Enum];Create;True;2;Material;0;Partical;1;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-900.8615,340.3819;Half;False;Property;_Disturbance;Disturbance;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-650.7534,810.8858;Float;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;33;-874.0877,927.0459;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;25;-207.6127,824.7454;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;31;-964.9686,319.2489;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-760.4294,113.9778;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;30;-538.1682,349.549;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-546.7704,573.6573;Half;False;Property;_Dissolve;Dissolve;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-173.2318,461.7534;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-375.7186,118.8725;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-14.01192,796.8394;Float;True;Property;_NoiseTex;NoiseTex;2;0;Create;True;0;0;False;0;None;fbeb42861f0d12f41b68cee79f714ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;9;438.988,799.8394;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;4;54.95589,287.6129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;908c9641b9abfd846bf19bccd670267d;80ab37a9e4f49c842903bb43bdd7bcd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;363.6999,56.50002;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;478.6298,389.3569;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;662.6599,56.39208;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;853.9001,56.60001;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/Dissolve/Flowmap;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;24;0;22;1
WireConnection;24;1;22;2
WireConnection;33;0;24;0
WireConnection;25;0;20;0
WireConnection;25;1;33;0
WireConnection;31;0;24;0
WireConnection;29;0;13;1
WireConnection;29;1;13;2
WireConnection;30;0;26;0
WireConnection;30;1;13;4
WireConnection;30;2;27;0
WireConnection;32;0;10;0
WireConnection;32;1;13;3
WireConnection;32;2;27;0
WireConnection;23;0;29;0
WireConnection;23;1;31;0
WireConnection;23;2;30;0
WireConnection;6;1;25;0
WireConnection;9;0;32;0
WireConnection;9;1;6;1
WireConnection;2;1;23;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;11;0;3;4
WireConnection;11;1;2;4
WireConnection;11;2;4;4
WireConnection;11;3;9;0
WireConnection;12;0;1;0
WireConnection;12;3;11;0
WireConnection;0;0;12;0
ASEEND*/
//CHKSM=7B124EB1B25F5BCF19295B989621B79CF173E3CF