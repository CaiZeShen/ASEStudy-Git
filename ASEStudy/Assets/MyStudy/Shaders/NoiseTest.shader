Shader "Custom/NoiseTest" {
	Properties{
		_MainTex("MainTex",2D) = "white"{}
	}
	SubShader{
		Pass{
			CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
			#include "UnityCG.cginc"

			float2 hash22(float2 p) {
				p = float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3)));
				return -1.0 + 2.0*frac(sin(p)*43758.5453123);
			}
			
			float2 hash21(float2 p) {
				float h=dot(p,float2(127.1,311.7));
				return -1.0 + 2.0*frac(sin(h)*43758.5453123);
			}

			//perlin
			float perlin_noise(float2 p) {				
				float2 pi = floor(p);
				float2 pf = p - pi;
				float2 w = pf * pf*(3.0 - 2.0*pf);
				return lerp(lerp(dot(hash22(pi + float2(0.0, 0.0)), pf - float2(0.0, 0.0)),
					dot(hash22(pi + float2(1.0, 0.0)), pf - float2(1.0, 0.0)), w.x),
					lerp(dot(hash22(pi + float2(0.0, 1.0)), pf - float2(0.0, 1.0)),
						dot(hash22(pi + float2(1.0, 1.0)), pf - float2(1.0, 1.0)), w.x), w.y);
			}

			//value
			float value_noise(float2 p) {
				float2 pi = floor(p);
				float2 pf = p - pi;
				float2 w = pf * pf*(3.0 - 2.0*pf);
				return lerp(lerp(hash21(pi+float2(0.0, 0.0)), hash21(pi + float2(1.0, 0.0)), w.x),
					lerp(hash21(pi + float2(0.0, 1.0)), hash21(pi + float2(1.0, 1.0)), w.x), w.y);
			}

			//simplex
			float simplex_noise(float2 p) {
				float k1 = 0.366025404;
				float k2 = 0.211324865;
				float2 i = floor(p + (p.x + p.y)*k1);
				float2 a = p - (i - (i.x + i.y)*k2);
				float2 o = (a.x < a.y) ? float2(0.0, 1.0) : float2(1.0, 0.0);
				float2 b = a - o + k2;
				float2 c = a - 1.0 + 2.0*k2;
				float3 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
				float3 n = h * h*h*h*float3(dot(a, hash22(i)), dot(b, hash22(i + o)), dot(c, hash22(i + 1.0)));
				return dot(float3(70.0, 70.0, 70.0), n);
			}

			//fbm分形叠加
			float noise_sum(float2 p) {
				float f = 0.0;
				p = p * 4.0;
				f += 1.0*perlin_noise(p);
				p = 2.0*p;
				f += 0.5*perlin_noise(p);
				p = 2.0*p;
				f += 0.25*perlin_noise(p);
				p = 2.0*p;
				f += 0.125*perlin_noise(p);
				p = 2.0*p;
				f += 0.0625*perlin_noise(p);
				return f;
			}

			float noise_sum_value(float2 p) {
				float f = 0.0;
				p = p * 4.0;
				f += 1.0*value_noise(p);
				p = 2.0*p;
				f += 0.5*value_noise(p);
				p = 2.0*p;
				f += 0.25*value_noise(p);
				p = 2.0*p;
				f += 0.125*value_noise(p);
				p = 2.0*p;
				f += 0.0625*value_noise(p);
				return f;
			}

			float noise_sum_simplex(float2 p) {
				float f = 0.0;
				p = p * 4.0;
				f += 1.0*simplex_noise(p);
				p = 2.0*p;
				f += 0.5*simplex_noise(p);
				p = 2.0*p;
				f += 0.25*simplex_noise(p);
				p = 2.0*p;
				f += 0.125*simplex_noise(p);
				p = 2.0*p;
				f += 0.0625*simplex_noise(p);
				return f;
			}

			//turbulence
			float noise_sum_abs(float2 p) {
				float f = 0.0;
				p = p * 7.0;
				f += 1.0*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.5*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.25*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.125*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(perlin_noise(p));
				return f;
			}

			float noise_sum_abs_value(float2 p) {
				float f = 0.0;
				p = p * 7.0;
				f += 1.0*abs(value_noise(p));
				p = 2.0*p;
				f += 0.5*abs(value_noise(p));
				p = 2.0*p;
				f += 0.25*abs(value_noise(p));
				p = 2.0*p;
				f += 0.125*abs(value_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(value_noise(p));
				return f;
			}

			float noise_sum_abs_simplex(float2 p) {
				float f = 0.0;
				p = p * 7.0;
				f += 1.0*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.5*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.25*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.125*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(simplex_noise(p));
				return f;
			}

			//turbulence_sin
			float noise_sum_abs_sin(float2 p) {
				float f = 0.0;
				p = p * 16.0;
				f += 1.0*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.5*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.25*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.125*abs(perlin_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(perlin_noise(p));
				p = 2.0*p;
				f = sin(f + p.x / 32.0);
				return f;
			}

			float noise_sum_abs_sin_value(float2 p) {
				float f = 0.0;
				p = p * 16.0;
				f += 1.0*abs(value_noise(p));
				p = 2.0*p;
				f += 0.5*abs(value_noise(p));
				p = 2.0*p;
				f += 0.25*abs(value_noise(p));
				p = 2.0*p;
				f += 0.125*abs(value_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(value_noise(p));
				p = 2.0*p;
				f = sin(f + p.x / 32.0);
				return f;
			}

			float noise_sum_abs_sin_simplex(float2 p) {
				float f = 0.0;
				p = p * 16.0;
				f += 1.0*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.5*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.25*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.125*abs(simplex_noise(p));
				p = 2.0*p;
				f += 0.0625*abs(simplex_noise(p));
				p = 2.0*p;
				f = sin(f + p.x / 32.0);
				return f;
			}

			float4 frag(v2f_img i) :SV_Target{

				float partOne,partTwo,partThree,partFour=0.0;		
				float partFive, partSix, partSeven, partEight = 0.0;
				float partNine, partTen, partEleven, partTwelve = 0.0;

				//分割区域
				if (i.uv.x<=0.5 && i.uv.y>0.5)
				{
					partOne = 1.0;
					partFive = 1.0;
					partNine = 1.0;
				}
				else
				{
					partOne = 0.0;
					partFive = 0.0;
					partNine = 0.0;
				}

				if (i.uv.x <= 0.5 && i.uv.y<=0.5)
				{
					partTwo = 1.0;
					partSix = 1.0;
					partTen = 1.0;
				}
				else
				{
					partTwo = 0.0;
					partSix = 0.0;
					partTen = 0.0;
				}

				if (i.uv.x > 0.5 && i.uv.y <= 0.5)
				{
					partThree = 1.0;
					partSeven = 1.0;
					partEleven = 1.0;

				}
				else
				{
					partThree = 0.0;
					partSeven = 0.0;
					partEleven = 0.0;
				}

				if (i.uv.x > 0.5 && i.uv.y > 0.5)
				{
					partFour = 1.0;
					partEight = 1.0;
					partTwelve = 1.0;
				}
				else
				{
					partFour = 0.0;
					partEight = 0.0;
					partTwelve = 0.0;
				}

				//柏林噪声
				float value1= perlin_noise(i.uv*8.0);

				//fbm分形叠加
				float value2 = noise_sum(i.uv);

				//turbulence
				float value3 = noise_sum_abs(i.uv);

				//大理石
				float value4 = noise_sum_abs_sin(i.uv);

				float val = value1 * partOne + value2 * partTwo + value3 * partThree + value4 * partFour;
				val = val * 0.45 + 0.45;

				float value5 = value_noise(i.uv*32.0);
				float value6 = noise_sum_value(i.uv);
				float value7 = noise_sum_abs_value(i.uv);
				float value8 = noise_sum_abs_sin_value(i.uv);

				float val2 = value5 * partFive + value6 * partSix + value7 * partSeven + value8 * partEight;
				val2 = val2 * 0.45 + 0.45;

				float value9 = simplex_noise(i.uv*4.0);
				float value10 = noise_sum_simplex(i.uv);
				float value11 = noise_sum_abs_simplex(i.uv);
				float value12 = noise_sum_abs_sin_simplex(i.uv);
				float val3 = value9 * partNine + value10 * partTen + value11 * partEleven + value12 * partTwelve;

				val3 = value9;
				val3 = val3 * 0.45 + 0.45;

				return float4(val3, val3, val3, 1);
			}
			ENDCG
        }
	}
	FallBack "Diffuse"
}
