Intent intent = new Intent();  
intent.setAction(android.content.Intent.ACTION_VIEW);  
intent.setType("image/*");
intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
startActivity(intent);