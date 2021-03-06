package com
{
	import by.blooddy.crypto.Base64;
	
	import com.errors.DOMError;
	
	import flash.utils.ByteArray;

	public class FileReaderSync
	{		
		
		public function readAsBase64(blob:*) : String {
			var ba:ByteArray;
						
			ba = _read(blob);
			
			if (ba.length > 1024 * 1024) { // 1mb
				throw new DOMError(DOMError.ENCODING_ERR);
			}
						
			return Base64.encode(ba);
		}
		
		
		private function _read(blob:*) : ByteArray {
			var src:Object, 
				ba:ByteArray = new ByteArray;
			
			if (typeof blob === 'string') {
				blob = Moxie.blobPile.get(blob);
			}
			
			if (!blob || !(blob is Blob) || blob.isEmpty()) {
				throw new DOMError(DOMError.NOT_FOUND_ERR);
			}
			
			for each (src in blob._sources) {
				if (src.buffer.isEmpty()) {
					break;
				}
				
				src.buffer.data.position = src.start;
				src.buffer.data.readBytes(ba, 0, src.end - src.start);				
			}
			return ba;
		}
	}
}