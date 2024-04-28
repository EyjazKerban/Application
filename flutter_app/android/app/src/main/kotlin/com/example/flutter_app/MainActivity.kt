package com.example.flutter_app

import androidx.annotation.NonNull;
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.net.URL
import android.content.ContentValues
import android.provider.MediaStore
import android.os.Environment
import java.io.InputStream
import java.io.OutputStream
import java.io.IOException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.flutter_app/downloads"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "downloadFile") {
                val url = call.argument<String>("url")
                val fileName = call.argument<String>("fileName")
                if (url != null && fileName != null) {
                    downloadFile(url, fileName, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "URL or fileName is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }



    private fun downloadFile(url: String, fileName: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val inputStream = URL(url).openStream()
                val values = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                }

                val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                contentResolver.openOutputStream(uri!!).use { outputStream ->
                    outputStream!!.copyFrom(inputStream)
                }
                launch(Dispatchers.Main) {
                    result.success("File downloaded to Downloads folder")
                }
            } catch (e: IOException) {
                launch(Dispatchers.Main) {
                    result.error("DOWNLOAD_ERROR", "Failed to download file: ${e.localizedMessage}", null)
                }
            }
        }
    }

    private fun OutputStream.copyFrom(inputStream: InputStream) {
        val buffer = ByteArray(4096)
        var read = inputStream.read(buffer)
        while (read != -1) {
            this.write(buffer, 0, read)
            read = inputStream.read(buffer)
        }
        inputStream.close()
    }
}
