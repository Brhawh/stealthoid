using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDetector : MonoBehaviour {

	void FixedUpdate() {
		for (int i = 0; i < 3; i++) {
			Vector2 direction = transform.up;
			if (i == 1) {
				direction = Quaternion.AngleAxis (4, Vector3.forward) * transform.up;
			} else if (i == 2) {
				direction = Quaternion.AngleAxis (-4, Vector3.forward) * transform.up;
			}
			RaycastHit2D hit = Physics2D.Raycast (transform.position, direction, 170f);
			if (hit.collider != null) {
				Debug.DrawRay (transform.position, hit.point - new Vector2 (transform.position.x, transform.position.y), Color.green);	
				if (hit.distance < 170f && hit.collider.gameObject.name == "Player") {
					Debug.Log ("Player detected!");
				}
			} else {
				Debug.DrawRay (transform.position, direction * 170f, Color.red);	
			}
		}
	}
}