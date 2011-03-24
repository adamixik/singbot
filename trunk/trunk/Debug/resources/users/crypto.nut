/*
 * ==============================
 * All-In-One Crypto System v0.1
 * ==============================
 *
 *  The contents of this file are subject to the Mozilla Public License      
 *  Version 1.1 (the "License"); you may not use this file except in         
 *  compliance with the License. You may obtain a copy of the License at     
 *  http://www.mozilla.org/MPL/                                              
 *                                                                           
 *  Software distributed under the License is distributed on an "AS IS"      
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the  
 *  License for the specific language governing rights and limitations       
 *  under the License.                                                       
 *
 *  The Original Code is All-In-One Crypto System
 *
 *  The Initial Developer of the Original Code is Jones Nathan Sperandio.
 *  Contributor(s): Flávio Toribio.
 */

/* ---------------------------
ROT13 and ROT47 encoding
--------------------------- */

function
	ROT13(string)
{
	local
		ret = "";
	
	foreach(c in string)
	{		
		if(c >= 0x41 && c <= 0x5A)
		{
			c = (c - 0x34) % 0x1A + 0x41;
		}
		else if(c >= 0x61 && c <= 0x7A)
		{
			c = (c - 0x5E) % 0x1A + 0x61;
		}
		ret += c.tochar();
	}
	return ret;
}

function
	ROT47(string)
{
	local
		ret = "";
	
	foreach(c in string)
	{
		if(c >= 0x21 && c <= 0x7E)
		{
			c = (c + 0x0E) % 0x5E + 0x21;
		}
		ret += c.tochar();
	}
	return ret;	
}

/* ----------------------------
Base64 encoding and decoding
---------------------------- */

local
	base64_keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

function
	base64_encode(input)
{
	local
		output = "",
		tmp,
		i = 0;

	while(i < input.len())
	{
		output += base64_keyStr[input[i] >> 0x02].tochar();
		
		tmp = (input[i++] & 0x03) << 0x04;
		if(i++ < input.len())
		{
			tmp = tmp | (input[i-1] >> 0x04);
		}
		output += base64_keyStr[tmp].tochar();
		
		if(i++ > input.len())
		{
			output += "==";
		}
		else if(i > input.len())
		{
			output += base64_keyStr[(input[i-2] & 0x0F) << 0x02].tochar() + "=";
		}
		else
		{
			output += base64_keyStr[((input[i-2] & 0x0F) << 0x02) | (input[i-1] >> 0x06)].tochar();
			output += base64_keyStr[input[i-1] & 0x3F].tochar();
		}			
	}   
	return output;
}

function
	base64_decode(input)
{
	local
		output = "",
		chr1, chr2, chr3,
		enc1, enc2, enc3, enc4,
		i = 0;

	while(i < input.len())
	{

		enc1 = findArrayIndex(base64_keyStr, input[i++]);
		enc2 = findArrayIndex(base64_keyStr, input[i++]);
		enc3 = findArrayIndex(base64_keyStr, input[i++]);
		enc4 = findArrayIndex(base64_keyStr, input[i++]);

		chr1 = (enc1 << 0x02) | (enc2 >> 0x04);
		chr2 = ((enc2 & 0x0F) << 0x04) | (enc3 >> 0x02);
		chr3 = ((enc3 & 0x03) << 0x06) | enc4;

		output += chr1.tochar();

		if(enc3 != 0x40)
		{
			output += chr2.tochar();
		}
		if(enc4 != 0x40)
		{
			output += chr3.tochar();
		}
	}
	return output;
}

/* ----------------------------
MD5 message digest
---------------------------- */

function rotateLeft(val, sbits)
{
	return (val << sbits) | (val >>> (0x20 - sbits));
}

function addUnsigned(x, y)
{
	local
		x4 = (x & 0x40000000),
		y4 = (y & 0x40000000),
		x8 = (x & 0x80000000),
		y8 = (y & 0x80000000),
		result = (x & 0x3FFFFFFF) + (y & 0x3FFFFFFF);

	if (x4 & y4)
	{
		return (result ^ 0x80000000 ^ x8 ^ y8);
	}
	if (x4 | y4)
	{
		if (result & 0x40000000)
		{
			return (result ^ 0xC0000000 ^ x8 ^ y8);
		}
		else
		{
			return (result ^ 0x40000000 ^ x8 ^ y8);
		}
	}
	else
	{
		return (result ^ x8 ^ y8);
	}
}

function F(x,y,z)
	return (x & y) | ((~x) & z);

function G(x,y,z)
	return (x & z) | (y & (~z));
	
function H(x,y,z)
	return (x ^ y ^ z);
	
function I(x,y,z)
	return (y ^ (x | (~z)));

function FF(a,b,c,d,x,s,ac)
{
	return addUnsigned(rotateLeft(addUnsigned(a, addUnsigned(addUnsigned(F(b, c, d), x), ac)), s), b);
}

function GG(a,b,c,d,x,s,ac)
{
	return addUnsigned(rotateLeft(addUnsigned(a, addUnsigned(addUnsigned(G(b, c, d), x), ac)), s), b);
}

function HH(a,b,c,d,x,s,ac)
{
	return addUnsigned(rotateLeft(addUnsigned(a, addUnsigned(addUnsigned(H(b, c, d), x), ac)), s), b);
}

function II(a,b,c,d,x,s,ac)
{
	return addUnsigned(rotateLeft(addUnsigned(a, addUnsigned(addUnsigned(I(b, c, d), x), ac)), s), b);
}

function convertToWordArray(string)
{
	local
		count = 0,
		len = string.len(),
		result = array((((len + 0x08) - ((len + 0x08) % 0x40)) / 0x40 + 1) * 0x10, 0),
		pos = 0,
		bcount = 0;

	while(bcount < len)
	{
		count = (bcount - (bcount % 0x04)) / 0x04;
		pos = (bcount % 0x04) * 0x08;
		result[count] = (result[count] | (string[bcount] << pos));
		bcount++;
	}

	count = (bcount - (bcount % 0x04)) / 0x04;
	pos = (bcount % 0x04) * 0x08;
	result[count] = result[count] | (0x80 << pos);
	result[result.len() - 2] = len << 0x03;
	result[result.len() - 1] = len >>> 0x1D;

	return result;
}

function wordToHex(value)
{
	local
		result = "",
		i;

	for(i = 0; i <= 3; i++)
	{
		result += format("%02x", (value >>> (i * 0x08)) & 0xFF);
	}
	return result;
}
 
function MD5(string)
{  
	local
		word_array,
		i, AA, BB, CC, DD,
		a = 0x67452301, b = 0xEFCDAB89,
		c = 0x98BADCFE, d = 0x10325476,
		S11 = 7, S12 = 12, S13 = 17, S14 = 22,
		S21 = 5, S22 = 9 , S23 = 14, S24 = 20,
		S31 = 4, S32 = 11, S33 = 16, S34 = 23,
		S41 = 6, S42 = 10, S43 = 15, S44 = 21,
 
	word_array = convertToWordArray(string);

	for(i = 0; i < word_array.len(); i += 0x10)
	{
		AA = a;
		BB = b;
		CC = c;
		DD = d;
		
		a = FF(a, b, c, d, word_array[i + 0x00], S11, 0xD76AA478);
		d = FF(d, a, b, c, word_array[i + 0x01], S12, 0xE8C7B756);
		c = FF(c, d, a, b, word_array[i + 0x02], S13, 0x242070DB);
		b = FF(b, c, d, a, word_array[i + 0x03], S14, 0xC1BDCEEE);
		a = FF(a, b, c, d, word_array[i + 0x04], S11, 0xF57C0FAF);
		d = FF(d, a, b, c, word_array[i + 0x05], S12, 0x4787C62A);
		c = FF(c, d, a, b, word_array[i + 0x06], S13, 0xA8304613);
		b = FF(b, c, d, a, word_array[i + 0x07], S14, 0xFD469501);
		a = FF(a, b, c, d, word_array[i + 0x08], S11, 0x698098D8);
		d = FF(d, a, b, c, word_array[i + 0x09], S12, 0x8B44F7AF);
		c = FF(c, d, a, b, word_array[i + 0x0A], S13, 0xFFFF5BB1);
		b = FF(b, c, d, a, word_array[i + 0x0B], S14, 0x895CD7BE);
		a = FF(a, b, c, d, word_array[i + 0x0C], S11, 0x6B901122);
		d = FF(d, a, b, c, word_array[i + 0x0D], S12, 0xFD987193);
		c = FF(c, d, a, b, word_array[i + 0x0E], S13, 0xA679438E);
		b = FF(b, c, d, a, word_array[i + 0x0F], S14, 0x49B40821);
		a = GG(a, b, c, d, word_array[i + 0x01], S21, 0xF61E2562);
		d = GG(d, a, b, c, word_array[i + 0x06], S22, 0xC040B340);
		c = GG(c, d, a, b, word_array[i + 0x0B], S23, 0x265E5A51);
		b = GG(b, c, d, a, word_array[i + 0x00], S24, 0xE9B6C7AA);
		a = GG(a, b, c, d, word_array[i + 0x05], S21, 0xD62F105D);
		d = GG(d, a, b, c, word_array[i + 0x0A], S22, 0x2441453);
		c = GG(c, d, a, b, word_array[i + 0x0F], S23, 0xD8A1E681);
		b = GG(b, c, d, a, word_array[i + 0x04], S24, 0xE7D3FBC8);
		a = GG(a, b, c, d, word_array[i + 0x09], S21, 0x21E1CDE6);
		d = GG(d, a, b, c, word_array[i + 0x0E], S22, 0xC33707D6);
		c = GG(c, d, a, b, word_array[i + 0x03], S23, 0xF4D50D87);
		b = GG(b, c, d, a, word_array[i + 0x08], S24, 0x455A14ED);
		a = GG(a, b, c, d, word_array[i + 0x0D], S21, 0xA9E3E905);
		d = GG(d, a, b, c, word_array[i + 0x02], S22, 0xFCEFA3F8);
		c = GG(c, d, a, b, word_array[i + 0x07], S23, 0x676F02D9);
		b = GG(b, c, d, a, word_array[i + 0x0C], S24, 0x8D2A4C8A);
		a = HH(a, b, c, d, word_array[i + 0x05], S31, 0xFFFA3942);
		d = HH(d, a, b, c, word_array[i + 0x08], S32, 0x8771F681);
		c = HH(c, d, a, b, word_array[i + 0x0B], S33, 0x6D9D6122);
		b = HH(b, c, d, a, word_array[i + 0x0E], S34, 0xFDE5380C);
		a = HH(a, b, c, d, word_array[i + 0x01], S31, 0xA4BEEA44);
		d = HH(d, a, b, c, word_array[i + 0x04], S32, 0x4BDECFA9);
		c = HH(c, d, a, b, word_array[i + 0x07], S33, 0xF6BB4B60);
		b = HH(b, c, d, a, word_array[i + 0x0A], S34, 0xBEBFBC70);
		a = HH(a, b, c, d, word_array[i + 0x0D], S31, 0x289B7EC6);
		d = HH(d, a, b, c, word_array[i + 0x00], S32, 0xEAA127FA);
		c = HH(c, d, a, b, word_array[i + 0x03], S33, 0xD4EF3085);
		b = HH(b, c, d, a, word_array[i + 0x06], S34, 0x4881D05);
		a = HH(a, b, c, d, word_array[i + 0x09], S31, 0xD9D4D039);
		d = HH(d, a, b, c, word_array[i + 0x0C], S32, 0xE6DB99E5);
		c = HH(c, d, a, b, word_array[i + 0x0F], S33, 0x1FA27CF8);
		b = HH(b, c, d, a, word_array[i + 0x02], S34, 0xC4AC5665);
		a = II(a, b, c, d, word_array[i + 0x00], S41, 0xF4292244);
		d = II(d, a, b, c, word_array[i + 0x07], S42, 0x432AFF97);
		c = II(c, d, a, b, word_array[i + 0x0E], S43, 0xAB9423A7);
		b = II(b, c, d, a, word_array[i + 0x05], S44, 0xFC93A039);
		a = II(a, b, c, d, word_array[i + 0x0C], S41, 0x655B59C3);
		d = II(d, a, b, c, word_array[i + 0x03], S42, 0x8F0CCC92);
		c = II(c, d, a, b, word_array[i + 0x0A], S43, 0xFFEFF47D);
		b = II(b, c, d, a, word_array[i + 0x01], S44, 0x85845DD1);
		a = II(a, b, c, d, word_array[i + 0x08], S41, 0x6FA87E4F);
		d = II(d, a, b, c, word_array[i + 0x0F], S42, 0xFE2CE6E0);
		c = II(c, d, a, b, word_array[i + 0x06], S43, 0xA3014314);
		b = II(b, c, d, a, word_array[i + 0x0D], S44, 0x4E0811A1);
		a = II(a, b, c, d, word_array[i + 0x04], S41, 0xF7537E82);
		d = II(d, a, b, c, word_array[i + 0x0B], S42, 0xBD3AF235);
		c = II(c, d, a, b, word_array[i + 0x02], S43, 0x2AD7D2BB);
		b = II(b, c, d, a, word_array[i + 0x09], S44, 0xEB86D391);
		a = addUnsigned(a, AA);
		b = addUnsigned(b, BB);
		c = addUnsigned(c, CC);
		d = addUnsigned(d, DD);
	}
 
	return wordToHex(a) + wordToHex(b) + wordToHex(c) + wordToHex(d);
}

/* ----------------------------
SHA1 hash
---------------------------- */

function SHA1(string)
{
	local
		i, s,
		W = array(80, 0),
		H0 = 0x67452301,
		H1 = 0xEFCDAB89,
		H2 = 0x98BADCFE,
		H3 = 0x10325476,
		H4 = 0xC3D2E1F0,
		A, B, C, D, E,
		temp,
		len = string.len(),
 		word_array = array(0);

	for(i = 0; i < len - 3; i += 4)
	{
		word_array.push(string[i] << 0x18 | string[i + 1] << 0x10 | string[i + 2] << 0x08 | string[i + 3]);
	}
 
	switch(len % 4)
	{
		case 0:
			i = 0x80000000;
		break;

		case 1:
			i = string[len - 1] << 0x18 | 0x0800000;
		break;
 
		case 2:
			i = string[len - 2] << 0x18 | string[len - 1] << 0x10 | 0x08000;
		break;
 
		case 3:
			i = string[len - 3] << 0x18 | string[len - 2] << 0x10 | string[len - 1] << 0x08 | 0x80;
		break;
	}
 
	word_array.push(i);
 
	while((word_array.len() % 0x10) != 0x0E)
		word_array.push(0);
 
	word_array.push(len >>> 0x1D);
	word_array.push((len << 0x03) & 0xFFFFFFFF);
 
 
	for(s = 0; s < word_array.len(); s += 0x10)
	{
 
		for(i = 0x00; i < 0x10; i++)
			W[i] = word_array[s + i];

		for(i = 0x10; i <= 0x4F; i++)
			W[i] = rotateLeft(W[i - 0x03] ^ W[i - 0x08] ^ W[i - 0x0E] ^ W[i - 0x10], 1);
 
		A = H0;
		B = H1;
		C = H2;
		D = H3;
		E = H4;
 
		for(i = 0x00; i <= 0x13; i++)
		{
			temp = (rotateLeft(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5A827999) & 0xFFFFFFFF;
			E = D;
			D = C;
			C = rotateLeft(B, 0x1E);
			B = A;
			A = temp;
		}
 
		for(i = 0x14; i <= 0x27; i++)
		{
			temp = (rotateLeft(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0xFFFFFFFF;
			E = D;
			D = C;
			C = rotateLeft(B, 0x1E);
			B = A;
			A = temp;
		}
 
		for(i = 0x28; i <= 0x3B; i++)
		{
			temp = (rotateLeft(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC) & 0xFFFFFFFF;
			E = D;
			D = C;
			C = rotateLeft(B, 0x1E);
			B = A;
			A = temp;
		}
 
		for(i = 0x3C; i <= 0x4F; i++)
		{
			temp = (rotateLeft(A, 5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0xFFFFFFFF;
			E = D;
			D = C;
			C = rotateLeft(B, 0x1E);
			B = A;
			A = temp;
		}
 
		H0 = (H0 + A) & 0xFFFFFFFF;
		H1 = (H1 + B) & 0xFFFFFFFF;
		H2 = (H2 + C) & 0xFFFFFFFF;
		H3 = (H3 + D) & 0xFFFFFFFF;
		H4 = (H4 + E) & 0xFFFFFFFF;
 
	}
 
	return format("%08x%08x%08x%08x%08x", H0, H1, H2, H3, H4);
 
}

/* ----------------------------
CRC32
---------------------------- */

function CRC32(string)
{
    local
		crc_table =
		[
			0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 
			0x9E6495A3, 0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD,
			0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D,
			0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 
			0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4, 
			0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B, 0x35B5A8FA, 0x42B2986C, 
			0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC, 
			0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F, 
			0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 
			0xB6662D3D, 0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 
			0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 
			0x086D3D2D, 0x91646C97, 0xE6635C01, 0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 
			0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 
			0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65, 0x4DB26158, 0x3AB551CE, 
			0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A, 
			0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9, 
			0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 
			0xCE61E49F, 0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 
			0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 
			0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 
			0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344, 0x8708A3D2, 0x1E01F268, 
			0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0, 
			0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5, 0xD6D6A3E8, 
			0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B, 
			0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 
			0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703, 
			0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 
			0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 
			0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713, 0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 
			0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242, 
			0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777, 0x88085AE6, 
			0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45, 
			0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D, 
			0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 
			0x47B2CF7F, 0x30B5FFE9, 0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 
			0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94, 
			0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
		],
		crc = -1;
		
    for(local i = 0; i < string.len(); i++)
    {
        crc = ( crc >>> 8 ) ^ crc_table[(crc ^ string[i]) & 0xFF];
    }
    return crc ^ -1;
}

/* utils */

function
	findArrayIndex(array, index)
{
	foreach(i, s in array)
	{
		if(index == s)
		{
			return i;
		}
	}
	return null;	
}