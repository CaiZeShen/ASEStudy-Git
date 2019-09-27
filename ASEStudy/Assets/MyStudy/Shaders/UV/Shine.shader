// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShenLin/UV/Shine"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_ShineTex("ShineTex", 2D) = "white" {}
		_Rotate("Rotate", Float) = 0
		_xOffset("xOffset", Float) = 0
		_yOffset("yOffset", Float) = 0
		_ShineColor("ShineColor", Color) = (1,1,1,1)
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
			};

			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _ShineTex;
			uniform half _Rotate;
			uniform half _xOffset;
			uniform half _yOffset;
			uniform half4 _ShineColor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
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
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv07 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult29 = lerp( uv07.x , uv07.y , _Rotate);
				float lerpResult30 = lerp( uv07.y , ( 1.0 - uv07.x ) , _Rotate);
				float2 appendResult33 = (float2(lerpResult29 , lerpResult30));
				float2 appendResult25 = (float2(_xOffset , _yOffset));
				float4 tex2DNode5 = tex2D( _ShineTex, (appendResult33*2.0 + appendResult25) );
				
				
				finalColor = ( ( _MainColor * tex2DNode2 ) + ( tex2DNode5 * tex2DNode5.a * _ShineColor * tex2DNode2.a ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
358;358;1466;807;2513.344;359.5724;2.168539;True;False
Node;AmplifyShaderEditor.CommentaryNode;35;-1224.26,-344.1151;Float;False;787.384;522.437;;4;29;33;30;31;另外一种旋转,角度只有90度;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1683.92,224.4121;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;31;-1174.26,-70.80609;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1484.83,685.6436;Half;False;Property;_Rotate;Rotate;3;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-703.9767,572.7876;Half;False;Property;_xOffset;xOffset;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-702.6769,662.4874;Half;False;Property;_yOffset;yOffset;5;0;Create;True;0;0;False;0;0;-0.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;-958.4648,-74.67805;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-1140.598,-294.1151;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-533.6769,601.3876;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-671.8755,-287.8349;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;28;-370.7261,327.3031;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;27;61.15946,584.2446;Half;False;Property;_ShineColor;ShineColor;6;0;Create;True;0;0;False;0;1,1,1,1;0.9716981,0.8578032,0.5821022,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;80ab37a9e4f49c842903bb43bdd7bcd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-76.62336,300.7671;Float;True;Property;_ShineTex;ShineTex;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;ab6b7469cffc4364e8081a116537067e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;341.9245,357.7872;Float;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;34;-832.3513,235.2131;Float;False;327;303;Comment;1;8;直接用旋转节点;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-980.0297,625.3434;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;18;-1205.03,597.3434;Float;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;8;-782.3513,285.2131;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;504.5563,67.08925;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;851.3,64.3;Half;False;True;2;Half;ASEMaterialInspector;0;1;ShenLin/UV/Shine;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;31;0;7;1
WireConnection;30;0;7;2
WireConnection;30;1;31;0
WireConnection;30;2;19;0
WireConnection;29;0;7;1
WireConnection;29;1;7;2
WireConnection;29;2;19;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;33;0;29;0
WireConnection;33;1;30;0
WireConnection;28;0;33;0
WireConnection;28;2;25;0
WireConnection;5;1;28;0
WireConnection;26;0;5;0
WireConnection;26;1;5;4
WireConnection;26;2;27;0
WireConnection;26;3;2;4
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;8;0;7;0
WireConnection;8;2;17;0
WireConnection;6;0;1;0
WireConnection;6;1;26;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=802089EF1C91B426D315239D7867C1230ABCC54A