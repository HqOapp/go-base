package main

import (
	"log"
	"net/http"
	"os"

	"github.com/healthimation/go-aws-config/src/awsconfig"
	"github.com/divideandconquer/go-consul-client/src/balancer"
)

// config keys
const (
	configKeyEnvironment = "AT_ENVIRONMENT"
	configKeyServiceMap  = "AT_SERVICE_MAP"
)

func main() {
	// pull environment from env vars
	env := os.Getenv(configKeyEnvironment)
	if len(env) == 0 {
		log.Fatal("environment not set")
	}
	// use the default service name to load config
	conf := awsconfig.NewAWSLoader(env, <serviceName>.DefaultServiceName)
	err := conf.Initialize()
	if err != nil {
		log.Fatalf("Couldnt initialize config: %v", err)
	}

	var serviceMap map[string]string
	serviceMapBy, err := conf.Get(configKeyServiceMap)
	if err != nil {
		log.Fatalf("Could not find config for %s", configKeyServiceMap)
	}
	err = json.Unmarshal(serviceMapBy, &serviceMap)
	if err != nil {
		log.Fatalf("Error decoding %s config %s", configKeyServiceMap, err.Error())
	}

	b := balancer.NewMapBalancer(serviceMap)
	svr := <serviceName>.NewServer(env, <serviceName>.DefaultServiceName, conf, b)

	// Start up the server
	log.Printf("Starting %s %s", env, <serviceName>.DefaultServiceName)
	log.Fatal(http.ListenAndServe(":8080", svr.GetRouter()))
}
