using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDetector : MonoBehaviour {

	void OnTriggerEnter2D (Collider2D other) {
		Debug.Log (other + " entered the light");
	}
}
