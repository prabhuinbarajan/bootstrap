use toolchain;
try {
db.Toolchain.deleteOne( { "_id" : ObjectId("58e56a68acac5a0020e2b930") } );
db.Toolchain.deleteOne( { "_id" : ObjectId("58e3fad09a148400216611cc") } );
db.Toolchain.deleteOne( { "_id" : ObjectId("58e573feacac5a001de2b932") } );
db.Toolchain.deleteOne( { "_id" : ObjectId("5909a34697b368001ead237a") } );
}catch (e) {
 print (e);
}
db.Toolchain.insertMany(
[
	{
		"_id" : ObjectId("58e3fad09a148400216611cc"),
		"orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
		"imageName" : "qubeship-python",
		"status" : "published",
		"modifiedBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
		"id" : "58cc31874117e7001ec0716f",
		"modifiedDate" : "1492503580",
		"statusMsg" : "success",
		"createdBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
		"visibility" : "public",
		"builderTrackingId" : "182",
		"description" : "Qubeship-Python-Toolchain",
		"tagName" : "v0.0.2",
		"sourceId" : "58dd9155c3817b0021b21030",
		"endpointId" : "e1234567890",
		"language" : "python",
		"isDefault" : true,
		"manifest" : "LS0tCmJ1aWxkLmNvbXBpbGU6ICJwaXAgbGlzdCAmJiB0b3ggLS1yZWNyZWF0ZSAtZSBweTMgLWUgbGludCAmJiBweXRob24gc2V0dXAucHkgYmRpc3Rfd2hlZWwiCmJ1aWxkLnVuaXR0ZXN0OiAibm9zZXRlc3RzIC0td2l0aC14dW5pdCBxdWJlL3Rlc3QgJiYgcHkudGVzdCAtLWNvdj1xdWJlIC0tY292LXJlcG9ydCBodG1sOmNvdl9odG1sIC0tY292LXJlcG9ydCB4bWw6Y292LnhtbCAtLWNvdi1yZXBvcnQgYW5ub3RhdGU6Y292X2Fubm90YXRlIC0tY292LXJlcG9ydD10ZXJtIgpidWlsZC5zdGF0aWNfY29kZV9hbmFseXNpczogImVjaG8gc3RhdGljX2NvZGVfYW5hbHlzaXMiCmJha2UuaGFyZGVuOiAiZWNobyBoYXJkZW4iCmRlcGxveV90b19xYS5mdW5jdGlvbmFsX3Rlc3Q6ICJlY2hvIGZ1bmN0aW9uYWxfdGVzdCIKZGVwbG95X3RvX3FhLm1hbnVhbF9hcHByb3ZlOiAiZWNobyBtYW51YWxfYXBwcm92ZSIK",
		"tenantId" : "d25a61af-3f88-3c58-9bff-0c44244f1d42",
		"dockerfile" : "RlJPTSBweXRob246My41DQoNClJVTiBwaXAgaW5zdGFsbCBlbnVtMzQgbW9jayBub3NlIHBlcDggcmVxdWVzdHMgdG94IHdoZWVsDQpSVU4gcGlwIGluc3RhbGwgY29sb3Jsb2c+PTIuNy4wDQpSVU4gcGlwIGluc3RhbGwgY292ZXJhZ2U9PTQuMy40DQpSVU4gcGlwIGluc3RhbGwgZmxhc2s+PTAuMTEuMQ0KUlVOIHBpcCBpbnN0YWxsIGZsYXNrX2NvcnM9PTMuMC4yDQpSVU4gcGlwIGluc3RhbGwgZmxhc2stcmVzdGZ1bD49MC4zLjUNClJVTiBwaXAgaW5zdGFsbCBmbGFzay1yZXN0ZnVsLXN3YWdnZXItMj49MC4zMQ0KUlVOIHBpcCBpbnN0YWxsIGZsYXNrLXN3YWdnZXItdWk9PTAuMC4yDQpSVU4gcGlwIGluc3RhbGwgRmxhc2stTW9uZ29BbGNoZW15PT0wLjcuMg0KUlVOIHBpcCBpbnN0YWxsIG1hZ2ljbW9jaz09MC4wMw0KUlVOIHBpcCBpbnN0YWxsIG1vbmdvbW9jaz09My43LjANClJVTiBwaXAgaW5zdGFsbCBweXRlc3QtY292PT0yLjQuMA0KUlVOIHBpcCBpbnN0YWxsIHV3c2dpDQo=",
		"name" : "Qubeship-Python-Toolchain",
		"createdDate" : "1491335888"
	},
	{
		"_id" : ObjectId("58e56a68acac5a0020e2b930"),
		"tagName" : "latest",
		"tenantId" : "d25a61af-3f88-3c58-9bff-0c44244f1d42",
		"language" : "java",
		"imageName" : "qubeship-java",
		"status" : "published",
		"orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
		"builderTrackingId" : "191",
		"manifest" : "YnVpbGQuY29tcGlsZTogJ212biBjbGVhbiBpbnN0YWxsJwpidWlsZC51bml0dGVzdDogJ212biB0ZXN0JwpidWlsZC5zdGF0aWNfY29kZV9hbmFseXNpczogJ3NvbmFyLXJ1bm5lcicKYmFrZS5oYXJkZW46ICdlY2hvIGhhcmRlbicKZGVwbG95X3RvX3FhLmUyZTogJ2JhdHMgJDEnCmRlcGxveV90b19xYS5mdW5jdGlvbmFsX3Rlc3Q6ICJlY2hvIGZ1bmN0aW9uYWxfdGVzdCIKZGVwbG95X3RvX3FhLm1hbnVhbF9hcHByb3ZlOiAiZWNobyBtYW51YWxfYXBwcm92ZSIK",
		"id" : "58e56a68acac5a0020e2b930",
		"endpointId" : "6v9123123456",
		"modifiedDate" : "1492026554",
		"name" : "Qubeship-Java-Toolchain",
		"createdBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
		"isDefault" : true,
		"modifiedBy" : "e92e2051-2674-3015-8bd2-34e870803f9c",
		"createdDate" : "1491429992",
		"description" : "java-ootb-toolchain",
		"visibility" : "public",
		"statusMsg" : "success",
		"dockerfile" : "RlJPTSBtYXZlbjozLjMtamRrLTgKClJVTiBhcHQtZ2V0IHVwZGF0ZSAmJiBhcHQtZ2V0IGluc3RhbGwgYmF0cwoKRU5WIFNPTkFSX1JVTk5FUl9WRVJTSU9OIDIuNApFTlYgU09OQVJfUlVOTkVSX0hPTUUgL29wdC9zb25hci1ydW5uZXItJHtTT05BUl9SVU5ORVJfVkVSU0lPTn0KRU5WIFNPTkFSX1JVTk5FUl9QQUNLQUdFIHNvbmFyLXJ1bm5lci1kaXN0LSR7U09OQVJfUlVOTkVSX1ZFUlNJT059LnppcApFTlYgSE9NRSAke1NPTkFSX1JVTk5FUl9IT01FfQpFTlYgUEFUSCAiJFBBVEg6JHtTT05BUl9SVU5ORVJfSE9NRX0vYmluIgpXT1JLRElSIC9vcHQKClJVTiB3Z2V0IGh0dHA6Ly9yZXBvMS5tYXZlbi5vcmcvbWF2ZW4yL29yZy9jb2RlaGF1cy9zb25hci9ydW5uZXIvc29uYXItcnVubmVyLWRpc3QvJHtTT05BUl9SVU5ORVJfVkVSU0lPTn0vJHtTT05BUl9SVU5ORVJfUEFDS0FHRX0gXAogJiYgdW56aXAgc29uYXItcnVubmVyLWRpc3QtJHtTT05BUl9SVU5ORVJfVkVSU0lPTn0uemlwIFwKICYmIHJtICR7U09OQVJfUlVOTkVSX1BBQ0tBR0V9CgojUlVOIGdyb3VwYWRkIC1yIHNvbmFyIFwKIyAmJiB1c2VyYWRkIC1yIC1zIC91c3Ivc2Jpbi9ub2xvZ2luIC1kICR7U09OQVJfUlVOTkVSX0hPTUV9IC1jICJTb25hciBzZXJ2aWNlIHVzZXIiIC1nIHNvbmFyIHNvbmFyIFwKIyAmJiBjaG93biAtUiBzb25hcjpzb25hciAke1NPTkFSX1JVTk5FUl9IT01FfSBcCiMgJiYgbWtkaXIgLXAgL2RhdGEgXAojICYmIGNob3duIC1SIHNvbmFyOnNvbmFyIC9kYXRhCiMgVVNFUiBzb25hcgoKV09SS0RJUiAvZGF0YQoKVk9MVU1FIC9kYXRhClJVTiBlY2hvICIiID4+ICR7U09OQVJfUlVOTkVSX0hPTUV9L2NvbmYvc29uYXItcnVubmVyLnByb3BlcnRpZXMKUlVOIGVjaG8gc29uYXIuaG9zdC51cmw9aHR0cDovL3NvbmFyLnF1YmVzaGlwLmlvID4+ICR7U09OQVJfUlVOTkVSX0hPTUV9L2NvbmYvc29uYXItcnVubmVyLnByb3BlcnRpZXMKCiNFTlRSWVBPSU5UICR7U09OQVJfUlVOTkVSX0hPTUV9L2Jpbi9zb25hci1ydW5uZXIKQ01EIFsibXZuIiwic29uYXItcnVubmVyIiwiYmF0cyJdCg=="
	},
	{
		"_id" : ObjectId("58e573feacac5a001de2b932"),
		"modifiedDate" : "1493667560",
		"status" : "published",
		"createdDate" : "1491432446",
		"createdBy" : "13e29f6d-be3b-3308-902c-aa8515803515",
		"sourceId" : "58e56a68acac5a0020e2b930",
		"statusMsg" : "success",
		"imageName" : "qubeship-gradle",
		"name" : "Qubeship-Gradle-Toolchain",
		"tagName" : "latest",
		"isDefault" : true,
		"language" : "java",
		"visibility" : "public",
		"manifest" : "YnVpbGQuY29tcGlsZTogJ2dyYWRsZSBidWlsZCAteCB0ZXN0ICcKYnVpbGQudW5pdHRlc3Q6ICdncmFkbGUgYnVpbGQnCmJ1aWxkLnN0YXRpY19jb2RlX2FuYWx5c2lzOiAnc29uYXItcnVubmVyJwpiYWtlLmhhcmRlbjogJ2VjaG8gaGFyZGVuJwpkZXBsb3lfdG9fcWEuZTJlOiAnYmF0cyAkMScKZGVwbG95X3RvX3FhLmZ1bmN0aW9uYWxfdGVzdDogImVjaG8gZnVuY3Rpb25hbF90ZXN0IgpkZXBsb3lfdG9fcWEubWFudWFsX2FwcHJvdmU6ICJlY2hvIG1hbnVhbF9hcHByb3ZlIgo=",
		"description" : "qubeship-gradle-toolchain",
		"endpointId" : "6v9123123456",
		"tenantId" : "c26cd23f-5bfc-3117-9181-34dbbe31c9cb",
		"builderTrackingId" : "227",
		"orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
		"id" : "58e573feacac5a001de2b932",
		"modifiedBy" : "ef322d6d-05f1-3625-b7af-ed0beeeee232",
		"dockerfile" : "I0ZST00gbWF2ZW46My4zLWpkay04CkZST00gZ3JhZGxlOjMuNS1qZGs4ClVTRVIgcm9vdApSVU4gYXB0LWdldCB1cGRhdGUgJiYgYXB0LWdldCBpbnN0YWxsIGJhdHMKCkVOViBTT05BUl9SVU5ORVJfVkVSU0lPTiAyLjQKRU5WIFNPTkFSX1JVTk5FUl9IT01FIC9vcHQvc29uYXItcnVubmVyLSR7U09OQVJfUlVOTkVSX1ZFUlNJT059CkVOViBTT05BUl9SVU5ORVJfUEFDS0FHRSBzb25hci1ydW5uZXItZGlzdC0ke1NPTkFSX1JVTk5FUl9WRVJTSU9OfS56aXAKRU5WIEhPTUUgJHtTT05BUl9SVU5ORVJfSE9NRX0KRU5WIFBBVEggIiRQQVRIOiR7U09OQVJfUlVOTkVSX0hPTUV9L2JpbiIKV09SS0RJUiAvb3B0CgpSVU4gd2dldCBodHRwOi8vcmVwbzEubWF2ZW4ub3JnL21hdmVuMi9vcmcvY29kZWhhdXMvc29uYXIvcnVubmVyL3NvbmFyLXJ1bm5lci1kaXN0LyR7U09OQVJfUlVOTkVSX1ZFUlNJT059LyR7U09OQVJfUlVOTkVSX1BBQ0tBR0V9IFwKICYmIHVuemlwIHNvbmFyLXJ1bm5lci1kaXN0LSR7U09OQVJfUlVOTkVSX1ZFUlNJT059LnppcCBcCiAmJiBybSAke1NPTkFSX1JVTk5FUl9QQUNLQUdFfQoKI1JVTiBncm91cGFkZCAtciBzb25hciBcCiMgJiYgdXNlcmFkZCAtciAtcyAvdXNyL3NiaW4vbm9sb2dpbiAtZCAke1NPTkFSX1JVTk5FUl9IT01FfSAtYyAiU29uYXIgc2VydmljZSB1c2VyIiAtZyBzb25hciBzb25hciBcCiMgJiYgY2hvd24gLVIgc29uYXI6c29uYXIgJHtTT05BUl9SVU5ORVJfSE9NRX0gXAojICYmIG1rZGlyIC1wIC9kYXRhIFwKIyAmJiBjaG93biAtUiBzb25hcjpzb25hciAvZGF0YQojIFVTRVIgc29uYXIKCldPUktESVIgL2RhdGEKClZPTFVNRSAvZGF0YQpSVU4gZWNobyAiIiA+PiAke1NPTkFSX1JVTk5FUl9IT01FfS9jb25mL3NvbmFyLXJ1bm5lci5wcm9wZXJ0aWVzClJVTiBlY2hvIHNvbmFyLmhvc3QudXJsPWh0dHA6Ly9zb25hci5xdWJlc2hpcC5pbyA+PiAke1NPTkFSX1JVTk5FUl9IT01FfS9jb25mL3NvbmFyLXJ1bm5lci5wcm9wZXJ0aWVzCgojRU5UUllQT0lOVCAke1NPTkFSX1JVTk5FUl9IT01FfS9iaW4vc29uYXItcnVubmVyCkNNRCBbIm12biIsInNvbmFyLXJ1bm5lciIsImJhdHMiXQo="
	},
	{
		"_id" : ObjectId("5909a34697b368001ead237a"),
		"tagName" : "latest",
		"visibility" : "public",
		"name" : "Qubeship-Jarvis-Toolchain",
		"modifiedDate" : "1493803846",
		"imageName" : "qubeship/jarvis-toolchain",
		"isDefault" : false,
		"tenantId" : "d25a61af-3f88-3c58-9bff-0c44244f1d42",
		"createdBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
		"manifest" : "YnVpbGQuY29tcGlsZTogJ3NlcnZpY2Ugc3VwZXJ2aXNvciBzdGFydCAmJiBncmFkbGUgYnVpbGQnCmJ1aWxkLnVuaXR0ZXN0OiAnZ3JhZGxlIGJ1aWxkJwpidWlsZC5zdGF0aWNfY29kZV9hbmFseXNpczogJ3NvbmFyLXJ1bm5lcicKYmFrZS5oYXJkZW46ICdlY2hvIGhhcmRlbicKZGVwbG95X3RvX3FhLmUyZTogJ2JhdHMgJDEnCmRlcGxveV90b19xYS5mdW5jdGlvbmFsX3Rlc3Q6ICJlY2hvIGZ1bmN0aW9uYWxfdGVzdCIKZGVwbG95X3RvX3FhLm1hbnVhbF9hcHByb3ZlOiAiZWNobyBtYW51YWxfYXBwcm92ZSIK",
		"orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
		"isFinal" : true,
		"language" : "java",
		"createdDate" : "1493803846",
		"modifiedBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
		"endpointId" : "123",
		"status" : "published"
	}
]
);
use opinions;
try {
db.Opinion.deleteOne( { "_id" : ObjectId("58e5596a13d0cc000e88a95d") } );
}catch (e) {
 print (e);
}
db.Opinion.insertMany(
[
	{
		"_id" : ObjectId("58e5596a13d0cc000e88a95d"),
		"yaml" : "LS0tCmlkOiAnNThlNTU5NmExM2QwY2MwMDBlODhhOTVkJwpuYW1lOiAnUXViZXNoaXAgZGVmYXVsdCBvcGluaW9uJwpkZXNjcmlwdGlvbjogJ2RlZmF1bHQgb3V0LW9mLXRoZS1ib3ggb3BpbmlvbicKdmlzaWJpbGl0eTogJ3B1YmxpYycKCnZhcmlhYmxlczoKICAtIG5hbWU6IEJBU0VfVVJMX0UyRQogICAgb3B0aW9uYWw6IHRydWUKICAtIG5hbWU6IERPQ0tFUkZJTEUKICAgIG9wdGlvbmFsOiBmYWxzZQogICAgdmFsdWU6IERvY2tlcmZpbGUKICAtIG5hbWU6IFBST0pFQ1RfTkFNRQogICAgb3B0aW9uYWw6IGZhbHNlCiAgICB2YWx1ZTogJChxdWJlc2hpcDpwcm9qZWN0OjpuYW1lKQogIC0gbmFtZTogdGFyZ2V0X3JlZ2lzdHJ5CiAgICBvcHRpb25hbDogdHJ1ZQogICAgdmFsdWU6ICQocXViZXNoaXA6ZW5kcG9pbnRzOltpc0RlZmF1bHQuZXEodHJ1ZSkuYW5kKHR5cGUuZXEoJ3JlZ2lzdHJ5JykpXSkKICAtIG5hbWU6IHRhcmdldF9rOHNfY2x1c3RlcgogICAgb3B0aW9uYWw6IGZhbHNlCiAgICB2YWx1ZTogJChxdWJlc2hpcDplbmRwb2ludHM6W2lzRGVmYXVsdC5lcSh0cnVlKS5hbmQodHlwZS5lcSgndGFyZ2V0JykpLmFuZChwcm92aWRlci5lcSgna3ViZXJuZXRlcycpKV0pCiAgLSBuYW1lOiBDT05UQUlORVJfTkFNRQogICAgb3B0aW9uYWw6IGZhbHNlCiAgICB2YWx1ZTogJChxdWJlc2hpcDpwcm9qZWN0Ojpjb250YWluZXJOYW1lKQogIC0gbmFtZTogQ09OVEFJTkVSX1RBRwogICAgb3B0aW9uYWw6IHRydWUKICAgIHZhbHVlOiBsYXRlc3QKICAtIG5hbWU6IEFDQ0VTU19UT0tFTgogICAgb3B0aW9uYWw6IHRydWUKICAgIHZhbHVlOiAkKHF1YmVzaGlwOnNlY3JldDpbaXNEZWZhdWx0LmVxKHRydWUpLmFuZCh0eXBlLmVxKCd0YXJnZXQnKSkuYW5kKHByb3ZpZGVyLmVxKCdrdWJlcm5ldGVzJykpXSkKCmlzRGVmYXVsdDogJ0ZhbHNlJwpncmFtbDoKICB2ZXJzaW9uOiAxLjAKZ3JhcGg6CiAgYnVpbGQ6CiAgICBoYXM6CiAgICAgIC0gY29tcGlsZQogICAgICAtIHVuaXR0ZXN0CiAgICAgIC0gc3RhdGljX2NvZGVfYW5hbHlzaXMKICAgIG9uX2Vycm9yOgogICAgICAtIG5vdGlmeQogICAgbmV4dDogYmFrZQogIGJha2U6CiAgICBoYXM6CiAgICAgIC0gZG9ja2VyX2J1aWxkCiAgICAgIC0gcHVzaF90b19yZWdpc3RyeQogICAgb25fZXJyb3I6CiAgICAgIC0gbm90aWZ5CiAgICBuZXh0OiBkZXBsb3lfdG9fcWEKICBkZXBsb3lfdG9fcWE6CiAgICBoYXM6CiAgICAgIC0gcmVsZWFzZV90b19xYQogICAgb25fZXJyb3I6CiAgICAgIC0gbm90aWZ5CiAgICBuZXh0OiBkZXBsb3lfdG9fcHJvZAogIGRlcGxveV90b19wcm9kOgogICAgaGFzOgogICAgICAtIHJlbGVhc2VfdG9fcHJvZAogICAgb25fZXJyb3I6CiAgICAgIC0gbm90aWZ5CiMgYmVsb3cgaXMgdGhlIGRlZmF1bHQgaW1wbGVtZW50YXRpb24KdmVydGljZXM6CiAgYnVpbGQ6CiAgICBza2lwcGFibGU6IHRydWUKICBiYWtlOgogICAgc2tpcHBhYmxlOiB0cnVlCiAgZG9ja2VyX2J1aWxkOgogICAgYWN0aW9uOgogICAgICAtICJkb2NrZXIgYnVpbGQgLXQgJDEgLWYgJDIgLiIKICAgIGFyZ3M6CiAgICAgIC0gJChDT05UQUlORVJfTkFNRSkKICAgICAgLSBEb2NrZXJmaWxlCiAgICBleGVjdXRlX291dHNpZGVfdG9vbGNoYWluOiB0cnVlCiAgcHVzaF90b19yZWdpc3RyeToKICAgIGFjdGlvbjoKICAgICAgLSAiZG9ja2VyIHRhZyAkMSAkMi8kMzokNCIKICAgICAgLSAiZG9ja2VyIHB1c2ggJDIvJDM6JDQiCiAgICBhcmdzOgogICAgICAtICQoQ09OVEFJTkVSX05BTUUpCiAgICAgIC0gJCh0YXJnZXRfcmVnaXN0cnkpLmFkZGl0aW9uYWxJbmZvLmFjY291bnQKICAgICAgLSAkKENPTlRBSU5FUl9OQU1FKQogICAgICAtICQoQ09OVEFJTkVSX1RBRykKICAgIGV4ZWN1dGVfb3V0c2lkZV90b29sY2hhaW46IHRydWUKICBkZXBsb3lfdG9fcWE6CiAgICBza2lwcGFibGU6IHRydWUKICByZWxlYXNlX3RvX3FhOgogICAgYWN0aW9uOgogICAgICAtICJlY2hvICQxIgogICAgYXJnczoKICAgICAgLSAiaGVsbG8gd29ybGQgLSBob3dkeT8iCiAgZGVwbG95X3RvX3Byb2Q6CiAgICBza2lwcGFibGU6IHRydWUKICByZWxlYXNlX3RvX3Byb2Q6CiAgICBhY3Rpb246CiAgICAgIC0gInF1YmVfdXRpbHMvZGVwbG95bWVudF90ZW1wbGF0ZXMvazhzL3F1YmVfZGVwbG95X2s4cy5zaCAkMTQvJDE6JDIgJDMgJDQgJDUtZGVwbG95bWVudCAvdG1wL2RlcGxveW1lbnQvJDYgJDcgJDggJDkgJDEwICQxMSAkMTIgJDEzIgogICAgYXJnczoKICAgICAgLSAkKENPTlRBSU5FUl9OQU1FKQogICAgICAtICQoQ09OVEFJTkVSX1RBRykKICAgICAgLSAkKHRhcmdldF9rOHNfY2x1c3RlcikuYWRkaXRpb25hbEluZm8ubmFtZXNwYWNlCiAgICAgIC0gJChDT05UQUlORVJfTkFNRSkKICAgICAgLSAkKENPTlRBSU5FUl9OQU1FKQogICAgICAtICQocXViZXNoaXA6ZW52OjpCVUlMRF9OVU1CRVIpCiAgICAgIC0gcXViZV9leHRlcm5hbF9hcHBfdjEKICAgICAgLSAkKHF1YmVzaGlwOmVudjo6V09SS1NQQUNFKQogICAgICAtICQodGFyZ2V0X2s4c19jbHVzdGVyKS5jYXRlZ29yeQogICAgICAtICQodGFyZ2V0X2s4c19jbHVzdGVyKS5pZAogICAgICAtICQodGFyZ2V0X2s4c19jbHVzdGVyKS50ZW5hbnQKICAgICAgLSAkKHRhcmdldF9rOHNfY2x1c3RlcikucHJvdmlkZXIKICAgICAgLSAkKHRhcmdldF9rOHNfY2x1c3RlcikuZW5kUG9pbnQKICAgICAgLSAkKHRhcmdldF9yZWdpc3RyeSkuYWRkaXRpb25hbEluZm8uYWNjb3VudAoK",
		"tenantId" : "0a39fe82-f235-33dc-afda-91dc85f1601f",
		"createdDate" : "1491425642",
		"isDefault" : false,
		"status" : "published",
		"createdBy" : "5c9d596e-d999-3ac4-bbf9-bee5d58c6566",
		"orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
		"visibility" : "public",
		"modifiedDate" : "1492465971",
		"description" : "default out-of-the-box opinion",
		"name" : "Qubeship default opinion",
		"modifiedBy" : "13e29f6d-be3b-3308-902c-aa8515803515"
	}
]
);
use qubeship;
if (true) {
    db.endPoint.remove(
        {_id: ObjectId("58edb422238503000b74d7a6")}
    );
    db.endPoint.remove(
        {_id: ObjectId("58e3fad42a0603000b3e58a8")}
    );

    db.endPoint.insertMany(
    [
        {
            "_id" : ObjectId("58edb422238503000b74d7a6"),
            "_class" : "com.ca.io.qubeship.model.EndPoint",
            "tenant" : "4b95bf35-1b75-3e8a-8b02-6e4dd989e098",
            "orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
            "owner" : "0e83ea2b-82cc-3846-bf4a-0c7fda85c085",
            "credentialId" : "925750d0-f719-4a69-8e07-5ff4f4fac400",
            "credentialPath" : "secret/resources/6727f870-5243-3f9e-bf11-0ce6e37bcfa0/production/creds/925750d0-f719-4a69-8e07-5ff4f4fac400",
            "createdBy" : "0e83ea2b-82cc-3846-bf4a-0c7fda85c085",
            "createdDate" : "1493916853258",
            "modifiedBy" : "0e83ea2b-82cc-3846-bf4a-0c7fda85c085",
            "modifiedDate" : "1493916853258",
            "credentialType" : "username_password",
            "name" : "Qubeship Default Docker Registry",
            "provider" : "generic",
            "category" : "production",
            "endPoint" : "https://registry.beta.qubeship.io:5001/",
            "type" : "registry",
            "visibility" : "public_",
            "isDefault" : true,
            "additionalInfo" : {
                "account" : "registry.beta.qubeship.io:5001/"
            }
        },
        {
            "_id" : ObjectId("58e3fad42a0603000b3e58a8"),
            "_class" : "com.ca.io.qubeship.model.EndPoint",
            "tenant" : "d25a61af-3f88-3c58-9bff-0c44244f1d42",
            "orgId" : "6727f870-5243-3f9e-bf11-0ce6e37bcfa0",
            "owner" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
            "credentialId" : "a7a08aec-8955-46e1-941d-7602b3190d41",
            "credentialPath" : "secret/resources/6727f870-5243-3f9e-bf11-0ce6e37bcfa0/production/creds/a7a08aec-8955-46e1-941d-7602b3190d41",
            "createdBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
            "createdDate" : "1491335892154",
            "modifiedBy" : "e2ba0158-f880-3f2c-b5eb-3e3745fd9c81",
            "modifiedDate" : "1492021530755",
            "sourceId" : "589933543c2d090006a6a48a",
            "credentialType" : "access_token",
            "name" : "Qubeship Sandbox Cluster",
            "provider" : "kubernetes",
            "category" : "production",
            "endPoint" : "https://192.168.99.101:8443",
            "type" : "target",
            "visibility" : "public_",
            "isDefault" : false,
            "additionalInfo" : {
                "namespace" : "default"
            }
        }
    ]);
}
