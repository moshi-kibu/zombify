describe("Checkin Controller Namespace", function() {
  it("is defined", function(){
    expect(CheckinController).toBeDefined()
  });
  it("has an initiate geolocation function", function(){
    expect(CheckinController.initiate_geolocation).toBeDefined()
  });
  it("has an handle_geolocation_query function", function(){
    expect(CheckinController.handle_geolocation_query).toBeDefined()
  });
  it("has a handle_errors function", function(){
    expect(CheckinController.handle_errors).toBeDefined()
  }); 
  it("has a compare_location function", function(){
    expect(CheckinController.compareLocation).toBeDefined()
  });
  xit("handle_geolocation_query sets userLat variable", function(){
    var e = {"coords": {"latitude": 32.12324}}
    CheckinController.handle_geolocation_query(e)
    expect(CheckinController.userLat).toBe(32.12324)
  });
  xit("handle_geolocation_query sets userLong variable", function(){

  });

})


